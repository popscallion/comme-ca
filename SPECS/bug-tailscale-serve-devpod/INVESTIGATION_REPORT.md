# Tailscale Serve Investigation Report

**Date**: 2025-12-31
**Agent**: Claude Code (Sonnet 4.5)
**Session Duration**: ~3 hours
**Status**: ⚠️ Root cause not yet identified - handoff required

---

## Executive Summary

Tailscale Serve is configured correctly on mneme-macbook-pro14, but TLS handshake **times out after 60 seconds** with error `tlsv1 alert internal error`. Despite extensive diagnostics, certificate provisioning fails (hangs indefinitely). MagicDNS and HTTPS are both enabled. Admin console shows certificate **expired**.

**Key Finding**: Both `tailscale serve reset && tailscale serve --bg 18080` and `tailscale cert` hang/timeout, indicating a deeper daemon or Let's Encrypt connectivity issue, not just a configuration problem.

**🚨 CRITICAL NEW CONTEXT (Added Post-Investigation)**:
User recently **migrated from App Store Tailscale to standalone version**. This process:
1. Assigned a NEW Tailscale IP and different short domain
2. User manually removed old offline device from admin console
3. User manually changed NEW device's IP/domain to match old values exactly (100.102.226.62, mneme-macbook-pro14)
4. Certificate provisioning has been broken since this migration
5. Temporarily renaming device to different name didn't fix the issue

**Hypothesis**: The migration may have created **orphaned certificate state** in Let's Encrypt, Tailscale control plane, or local daemon that blocks new certificate provisioning for this device identity.

---

## What We've Confirmed ✅

### 1. Tailscale Daemon Healthy
```bash
$ tailscale status --json | jq -r '.BackendState,.Self.Online'
Running
true
```

### 2. Serve Configuration Exists
```json
{
  "TCP": {"443": {"HTTPS": true}},
  "Web": {
    "mneme-macbook-pro14.ayu-scylla.ts.net:443": {
      "Handlers": {"/": {"Proxy": "http://127.0.0.1:18080"}}
    }
  }
}
```

### 3. Port 443 Listening (Network Extension Level)
```bash
$ netstat -an | grep "\.443.*LISTEN"
tcp4       0      0  *.443                  *.*                    LISTEN
tcp6       0      0  *.443                  *.*                    LISTEN
```

**Note**: `lsof -iTCP:443 -sTCP:LISTEN` returns nothing because Tailscale uses system extension (kernel-level), not user-space process.

### 4. Backend Service Working
```bash
$ curl -s http://127.0.0.1:18080 | head -5
<!-- Copyright (C) Microsoft Corporation. All rights reserved. -->
<!DOCTYPE html>
<html>
...
```

OpenVSCode tunnel is active via SSH (port 18080 bound by SSH process PID 3903).

### 5. MagicDNS Enabled
```bash
$ tailscale status --json | rg MagicDNS
"MagicDNSSuffix": "ayu-scylla.ts.net",
"MagicDNSEnabled": true
```

### 6. HTTPS Enabled in Tailnet
Confirmed by user: Admin console DNS settings show HTTPS certificates enabled.

### 7. Tailscale Version
```bash
$ tailscale version
1.92.3
  tailscale commit: a17f36b9ba505fa624a2e69034741dbd212c1141
```

**Note**: Standalone version, recently migrated from App Store version.

### 8. Device Migration History (CRITICAL)

**Timeline**:
1. **Before**: App Store version of Tailscale installed
   - Had original Tailscale IP and domain
   - Had working certificates (presumably)

2. **Migration Event**: Uninstalled App Store version, installed standalone
   - System assigned NEW Tailscale IP
   - System assigned NEW short domain name
   - Device appeared as new/different identity in admin console

3. **Manual Remediation**:
   - Removed old offline device from admin console
   - Changed NEW device IP to match old: `100.102.226.62`
   - Changed NEW device domain to match old: `mneme-macbook-pro14`

4. **Result**: Certificate provisioning broken since migration

**Significance**:
- Let's Encrypt may have ACME account registration tied to old device identity
- Tailscale control plane may have certificate bindings to old device ID
- Local daemon may have cached ACME account keys from old installation
- DNS challenge records may be registered under old device identity
- Domain name change may have created conflicting certificate state

---

## What Fails ❌

### 1. TLS Handshake Times Out
```bash
$ curl -vk --max-time 20 https://mneme-macbook-pro14.ayu-scylla.ts.net/
* Connected to mneme-macbook-pro14.ayu-scylla.ts.net (100.102.226.62) port 443
* ALPN: curl offers h2,http/1.1
* (304) (OUT), TLS handshake, Client hello (1):
[60 second timeout...]
* LibreSSL/3.3.6: error:1404B438:SSL routines:ST_CONNECT:tlsv1 alert internal error
```

**Pattern**: Connection establishes, TLS handshake starts, then **hangs for 60s** before timeout.

### 2. Certificate Provisioning Hangs Indefinitely
```bash
$ tailscale cert mneme-macbook-pro14.ayu-scylla.ts.net
[hangs forever - no output, no timeout]
```

Requires manual Ctrl+C to terminate.

### 3. Admin Console: Certificate Expired
**Location**: https://login.tailscale.com/admin/machines
**mneme-macbook-pro14 TLS Certificate Status**: **Expired**

### 4. LocalAPI Endpoint Returns 404
```bash
$ tailscale debug localapi /v0/serve-config
404 page not found
```

Suggests serve configuration not registered at daemon API level (state desync).

---

## What We've Tried (All Failed)

### Attempt 1: Reset Serve Configuration
```bash
$ tailscale serve reset
$ tailscale serve --bg 18080
Available within your tailnet:
https://mneme-macbook-pro14.ayu-scylla.ts.net/
|-- proxy http://127.0.0.1:18080

$ curl -vk --max-time 20 https://mneme-macbook-pro14.ayu-scylla.ts.net/
[timeout - same behavior]
```

**Result**: Configuration recreated successfully, but TLS handshake still times out.

### Attempt 2: Explicit Certificate Renewal
```bash
$ tailscale cert mneme-macbook-pro14.ayu-scylla.ts.net
[hangs indefinitely - no output]
```

**Result**: Command never completes. Let's Encrypt DNS-01 challenge appears to hang.

### Attempt 3: Alternative Certificate Flags
```bash
$ tailscale cert --cert-file - --key-file /dev/null mneme-macbook-pro14.ayu-scylla.ts.net
[interrupted - was hanging]
```

**Result**: Same hang behavior with different output flags.

---

## Hypotheses Tested & Results

| Hypothesis | Test | Result | Status |
|:-----------|:-----|:-------|:-------|
| GUI app not running | `ps aux \| grep Tailscale` | Both app (PID 2163) and extension (PID 2191) running | ❌ Disproven |
| HTTPS not enabled in Tailnet | User confirmation + admin console | HTTPS enabled | ❌ Disproven |
| MagicDNS not enabled | `tailscale status --json` | `MagicDNSEnabled: true` | ❌ Disproven |
| Port 443 not listening | `netstat -an \| grep 443` | Listening on `*:443` | ❌ Disproven |
| Backend not responding | `curl http://127.0.0.1:18080` | Returns OpenVSCode HTML | ❌ Disproven |
| Stale serve config | `tailscale serve reset` | Config reset, but issue persists | ❌ Didn't fix |
| Expired certificate | Admin console | **CONFIRMED: Certificate expired** | ✅ **ROOT CAUSE** |
| Certificate renewal | `tailscale cert` | Hangs indefinitely | ⚠️ **BLOCKS FIX** |
| State desync bug | GitHub #10977 reference | LocalAPI 404 suggests possible | ⚠️ **POSSIBLE** |
| **App Store → standalone migration** | **Device identity change** | **IP/domain manually reassigned to match old** | ⚠️ **LIKELY ROOT CAUSE** |

---

## Current Understanding

### The Problem Chain

1. ✅ Certificate **expired** (confirmed in admin console)
2. ✅ Serve listener **active** (port 443 accepting connections)
3. ❌ Certificate **renewal fails** (`tailscale cert` hangs)
4. ❌ TLS handshake **cannot complete** (no valid cert available)
5. ⏱️ Timeout after 60 seconds

### The Mystery

**Why does `tailscale cert` hang?**

Given:
- ✅ MagicDNS enabled
- ✅ HTTPS enabled
- ✅ Daemon running
- ✅ Device online
- ✅ Version recent (v1.92.3)

Expected behavior: Command completes in 5-10 seconds with Let's Encrypt certificate.

Actual behavior: Hangs indefinitely, no output, no error.

**Possible Causes** (ordered by likelihood):

1. **🚨 Orphaned certificate state from migration** (MOST LIKELY):
   - Let's Encrypt ACME account registration tied to old device identity
   - Tailscale control plane certificate bindings to old device ID (pre-migration)
   - Local ACME account keys cached from old installation
   - DNS TXT challenge records registered under old device that no longer exists
   - Control plane confusion: new device ID but old domain name already has cert state

2. **Let's Encrypt rate limiting**: Exceeded renewal attempts during migration/testing → 34-hour wait
3. **DNS-01 challenge failure**: Tailscale can't create/verify TXT records due to identity conflict
4. **Control plane connectivity**: Can't reach `https://controlplane.tailscale.com`
5. **Local firewall/security**: Blocking outbound certificate requests
6. **System time skew**: macOS clock incorrect → cert validation fails
7. **Daemon state bug**: GitHub #10977 - serve subsystem not properly initialized

---

## Diagnostic Commands Run

### System & Network
```bash
ps aux | grep -i tailscale                    # Both app and extension running
netstat -an | grep "\.443.*LISTEN"            # Port 443 listening
lsof -iTCP:443 -sTCP:LISTEN                   # Empty (system extension)
lsof -iTCP:18080 -sTCP:LISTEN                 # SSH tunnel active
```

### Tailscale Status
```bash
tailscale version                             # 1.92.3
tailscale status                              # Running, online
tailscale status --json | jq .BackendState    # "Running"
tailscale status --json | jq .MagicDNSEnabled # true
tailscale status --json | jq .Self.Online     # true
```

### Serve Configuration
```bash
tailscale serve status                        # Shows config
tailscale serve status --json                 # Full config JSON
tailscale debug localapi /v0/serve-config     # 404 Not Found
```

### Certificate Tests
```bash
tailscale cert mneme-macbook-pro14.ayu-scylla.ts.net  # Hangs
tailscale cert --cert-file - --key-file /dev/null ... # Hangs
```

### Connection Tests
```bash
curl http://127.0.0.1:18080                   # Returns HTML (backend OK)
curl -vk https://mneme-macbook-pro14.ayu-scylla.ts.net/  # TLS timeout
```

### Logs
```bash
log show --predicate 'process == "Tailscale"' --info --last 30m | grep -i serve
# No serve-specific errors found
```

---

## Research Conducted

### Documentation Sources

1. **Tailscale KB** (via Context7 MCP):
   - `/websites/tailscale_kb` - Serve, HTTPS, certificate provisioning
   - Key finding: Certificates provision **lazily on first connection** (10-15s delay expected)

2. **Perplexity Search**:
   - "getCertPEM: context deadline exceeded" error research
   - LocalAPI 404 behavior (GitHub #10977 - state desync bug)
   - TLS handshake timeout causes

3. **GitHub Issues**:
   - #10977: Serve state inconsistency (status vs API endpoint)
   - #9976: Certificate provisioning timeouts in k8s
   - #5937: TLS handshake failures to control plane

### Key Findings from Research

**Certificate Provisioning Requirements**:
- MagicDNS must be enabled ✅
- HTTPS must be enabled in tailnet ✅
- Device must be online ✅
- Let's Encrypt DNS-01 challenge via Tailscale-created TXT records

**Known Issues**:
- **State desync**: Config persists while daemon serving stops (GitHub #10977)
- **Lazy provisioning**: First connection triggers cert request (10-15s delay)
- **Rate limiting**: Frequent cert requests hit Let's Encrypt limits (34-hour wait)
- **Manual renewal**: File-based certs (`tailscale cert`) require manual renewal every 90 days

**Auto-renewal Caveat**:
> "When a certificate is delivered as files on disk... the `tailscaled` daemon doesn't know where to place a renewed certificate nor how to install it. So for any certificates that you create using `tailscale cert`, you are responsible for renewing the certificate."

But `tailscale serve` **should** auto-renew certificates internally (doesn't write to disk).

---

## Remaining Unknowns

### Critical Questions

1. **Why does `tailscale cert` hang?**
   - Is Let's Encrypt blocking requests (rate limit)?
   - Is DNS-01 challenge failing silently?
   - Is control plane unreachable from mneme?

2. **Why didn't serve auto-renew the certificate?**
   - Was serve stopped during renewal window?
   - Is there a daemon bug preventing auto-renewal?
   - Did state desync break renewal mechanism?

3. **Can we bypass certificate provisioning?**
   - Use HTTP-only serve (no TLS)?
   - Use alternative proxy (Caddy with Tailscale TLS)?
   - Use direct SSH tunnel instead?

### Missing Diagnostics

1. **🚨 Orphaned certificate state from migration** (HIGHEST PRIORITY):
   - Local ACME account key files from old installation
   - Tailscale control plane device ID vs certificate bindings
   - DNS TXT records tied to old device identity
   - Let's Encrypt account registration conflicts

2. **Let's Encrypt rate limit status**: Check if domain is rate-limited
3. **Control plane connectivity**: Test `curl https://controlplane.tailscale.com`
4. **DNS TXT record creation**: Verify Tailscale can create TXT records for `_acme-challenge.mneme-macbook-pro14.ayu-scylla.ts.net`
5. **System time accuracy**: Verify `date` is correct (cert validation depends on clock)
6. **Daemon logs (verbose)**: Enable debug logging to see cert request flow
7. **Firewall rules**: Check if macOS firewall is blocking outbound ACME requests
8. **Certificate cache**: Check if expired cert is cached preventing renewal
9. **Device identity history**: Query Tailscale API for previous device with same name/IP

---

## Next Steps for Agent

### 🚨 Priority 0: Investigate Migration Certificate State (NEW - HIGHEST PRIORITY)

**The App Store → standalone migration is likely the root cause.** Investigate certificate state orphaned from old device identity:

#### 0.1: Check Local Certificate State Files

**On mneme, look for cached ACME state**:
```bash
# Check for Tailscale state directory
ls -la /Library/Tailscale/
ls -la ~/Library/Tailscale/
ls -la /var/lib/tailscale/

# Look for ACME account keys or certificate cache
find /Library/Tailscale -name "*acme*" -o -name "*cert*" -o -name "*.key" -o -name "*.crt" 2>/dev/null
find ~/Library/Tailscale -name "*acme*" -o -name "*cert*" -o -name "*.key" -o -name "*.crt" 2>/dev/null

# Check for state.conf or similar
find /Library/Tailscale -name "*.conf" -o -name "state" 2>/dev/null
```

#### 0.2: Completely Remove and Re-Add Device

**Nuclear option - fresh device identity**:
```bash
# From mneme
sudo tailscale down
sudo tailscale logout

# CRITICAL: Back up any important Tailscale state first
sudo cp -r /Library/Tailscale /tmp/tailscale-backup-$(date +%s)

# Optional: Manually clean state (RISKY - only if desperate)
# sudo rm -rf /Library/Tailscale/*
# sudo rm -rf ~/Library/Tailscale/*

# Re-login (will get FRESH device ID and domain)
sudo tailscale up

# Check new identity
tailscale status
# Device will have NEW name, NEW IP - this is expected

# Then in admin console:
# 1. Rename device to "mneme-macbook-pro14-new" (don't reuse old name yet)
# 2. Try certificate provisioning with NEW identity:
tailscale cert mneme-macbook-pro14-new.ayu-scylla.ts.net
# If this works, the old identity was blocking provisioning

# 3. Only after cert works, consider renaming to old name
```

#### 0.3: Check Tailscale Control Plane Certificate State

**Query admin console API for certificate metadata**:
```bash
# Get API key from: https://login.tailscale.com/admin/settings/keys
export TAILSCALE_API_KEY="tskey-api-..."

# List devices and check certificate status
curl -H "Authorization: Bearer $TAILSCALE_API_KEY" \
  https://api.tailscale.com/api/v2/tailnet/ayu-scylla.ts.net/devices | \
  jq '.devices[] | select(.name | contains("mneme")) | {name, id, hostname, authorized, tlsCertificate}'

# Check if old device ID still has certificate state
```

#### 0.4: Force DNS TXT Record Cleanup

**Check for stale challenge records from old device**:
```bash
# From any device on tailnet
dig TXT _acme-challenge.mneme-macbook-pro14.ayu-scylla.ts.net

# If records exist, they may be from old device
# Try requesting cert with different domain temporarily:
tailscale cert mneme-macbook-pro14-test.ayu-scylla.ts.net
# If this works but original domain doesn't, confirms domain-specific state issue
```

#### 0.5: Test with Completely Fresh Domain

**Bypass any old domain state**:
```bash
# Rename device in admin console to something completely new
# e.g., "mneme-test-2025"

# Then test cert provisioning on fresh domain
tailscale cert mneme-test-2025.ayu-scylla.ts.net

# If this works instantly → confirms old domain name has orphaned state
# If this also hangs → problem is device-ID-level, not domain-name-level
```

---

### Priority 1: Verify Let's Encrypt Connectivity

**Test if mneme can reach Let's Encrypt**:
```bash
# From mneme
curl -v https://acme-v02.api.letsencrypt.org/directory

# Expected: JSON response with directory endpoints
# Failure: Timeout or connection refused → network/firewall issue
```

### Priority 2: Check System Time

**Clock skew can break cert validation**:
```bash
# From mneme
date
ntpdate -q time.apple.com

# If time is off by >5 minutes, sync:
sudo ntpdate -u time.apple.com
```

### Priority 3: Enable Debug Logging

**Capture verbose daemon logs**:
```bash
# From mneme (in separate terminal)
log stream --predicate 'process == "Tailscale"' --level debug > /tmp/tailscale-debug.log

# Then in another terminal, attempt cert request:
tailscale cert mneme-macbook-pro14.ayu-scylla.ts.net

# After hang (or 60s), Ctrl+C and review /tmp/tailscale-debug.log
# Look for: "getCertPEM", "ACME", "DNS-01", "TXT record", "rate limit"
```

### Priority 4: Test DNS TXT Record Creation

**Verify Tailscale can create challenge records**:
```bash
# From any device on tailnet
dig TXT _acme-challenge.mneme-macbook-pro14.ayu-scylla.ts.net

# If empty or NXDOMAIN → DNS propagation issue
# If populated → challenge record exists (check if stale)
```

### Priority 5: Alternative: Use HTTP-Only Serve

**Bypass TLS entirely for testing**:
```bash
# From mneme
tailscale serve reset
tailscale serve --http=8080 http://127.0.0.1:18080

# Test from eos:
curl http://mneme-macbook-pro14.ayu-scylla.ts.net:8080/

# If this works → confirms issue is TLS-specific, not serve itself
```

### Priority 6: Restart Tailscale Daemon

**Clear any stale state**:
```bash
# From mneme (requires sudo)
sudo launchctl unload /Library/LaunchDaemons/com.tailscale.tailscaled.plist
sleep 5
sudo launchctl load /Library/LaunchDaemons/com.tailscale.tailscaled.plist

# Verify restart
tailscale status

# Then retry cert provisioning
tailscale cert mneme-macbook-pro14.ayu-scylla.ts.net
```

---

## Alternative Workarounds

If certificate provisioning remains blocked, consider:

### Option A: Direct SSH Tunnel (No Tailscale Serve)

**From eos/phone**:
```bash
ssh l@mneme-macbook-pro14 -L 18080:127.0.0.1:18080 -N

# Access in browser: http://localhost:18080
```

**Downside**: Requires active SSH connection.

### Option B: Caddy Reverse Proxy with Tailscale TLS

**On mneme**:
```bash
brew install caddy

# Create Caddyfile:
cat > /tmp/Caddyfile <<EOF
mneme-macbook-pro14.ayu-scylla.ts.net {
  reverse_proxy 127.0.0.1:18080
  tls {
    get_certificate tailscale
  }
}
EOF

# Run Caddy
caddy run --config /tmp/Caddyfile
```

Caddy integrates with Tailscale daemon and may succeed where `tailscale cert` fails.

### Option C: Tailscale Funnel (Public Access)

**On mneme**:
```bash
tailscale funnel --bg 18080

# Creates public HTTPS URL (no private tailnet required)
# WARNING: Exposes service to public internet
```

---

## Files Updated

### Documentation Created
- ✅ `RESOLUTION.md` - Initial resolution attempt (HTTPS enablement theory)
- ✅ `_ENTRYPOINT.md` - Updated with diagnostic results and lessons learned
- ✅ `INVESTIGATION_REPORT.md` - This comprehensive handoff (NEW)

### Files to Update After Resolution

1. **`comme-ca/DOCS/DEVPOD_REMOTE_PLAYBOOK.md`**:
   - Add troubleshooting section for expired certificates
   - Add diagnostic commands (netstat, tailscale cert check)
   - Document Let's Encrypt rate limiting risk

2. **`comme-ci/docs/devpod-host-setup.md`**:
   - Add certificate renewal monitoring to checklist
   - Add troubleshooting section for cert expiry
   - Document automatic vs manual renewal distinction

3. **`SPECS/bug-tailscale-serve-devpod/_ENTRYPOINT.md`**:
   - Update with final root cause once identified
   - Add prevention steps (renewal monitoring)

---

## References

### Tailscale Documentation
- [Tailscale Serve](https://tailscale.com/kb/1312/serve)
- [tailscale serve command](https://tailscale.com/kb/1242/tailscale-serve)
- [Enabling HTTPS](https://tailscale.com/kb/1153/enabling-https)
- [Troubleshooting guide](https://tailscale.com/kb/1023/troubleshooting)
- [Kubernetes operator troubleshooting](https://tailscale.com/kb/1446/kubernetes-operator-troubleshooting)

### GitHub Issues
- [#10977](https://github.com/tailscale/tailscale/issues/10977) - Serve state inconsistency
- [#9976](https://github.com/tailscale/tailscale/issues/9976) - getCertPEM timeout
- [#5937](https://github.com/tailscale/tailscale/issues/5937) - TLS handshake failures

### Let's Encrypt
- [Rate Limits](https://letsencrypt.org/docs/rate-limits/)
- [DNS-01 Challenge](https://letsencrypt.org/docs/challenge-types/#dns-01-challenge)

---

## Agent Notes

**Time Invested**: ~3 hours of diagnostic work
**Blockers**: Certificate provisioning hangs indefinitely, preventing resolution
**Recommendation**: Focus on Let's Encrypt connectivity and debug logging as first priorities

**Critical Insight**: The fact that both `tailscale serve` TLS handshake AND `tailscale cert` command hang suggests a **common underlying issue** with Let's Encrypt certificate acquisition, not separate bugs in serve and cert subsystems.

**🚨 MOST LIKELY ROOT CAUSE**: The **App Store → standalone migration** with manual IP/domain reassignment created orphaned certificate state. The new device has the old device's name/IP but a different internal device ID, causing:
- Let's Encrypt ACME account conflicts (old device registered, new device can't re-register same domain)
- Tailscale control plane confusion (certificate bindings to old device ID that no longer exists)
- DNS TXT challenge records stuck with old device identity
- Local daemon unable to provision certs due to identity mismatch

Other possible causes:
- Network/firewall blocking ACME protocol
- Rate limiting by Let's Encrypt (from repeated cert attempts during migration)
- Control plane connectivity issues
- Fundamental daemon bug in certificate state management

**The next agent should start with Priority 0 diagnostics (migration state cleanup) FIRST, then Priority 1-4 if that doesn't resolve it.**

**Quick Test**: Rename device to completely new name (e.g., "mneme-test-2025") and try `tailscale cert` with new domain. If it works instantly, confirms old domain name has orphaned state blocking provisioning.
