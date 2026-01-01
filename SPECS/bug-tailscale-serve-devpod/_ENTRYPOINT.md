<!--
@id: bug-tailscale-serve-devpod-entrypoint
@version: 1.0.0
@model: codex
-->
# Iteration Dashboard: Tailscale Serve + DevPod OpenVSCode

| Status | Description | Owner |
| :--- | :--- | :--- |
| **🔴 BLOCKED** | Certificate provisioning hangs - needs deeper diagnostics | Next Agent |

## Current Status (2025-12-31)

**Problem**: Certificate expired, renewal blocked
**Blocker**: `tailscale cert` command hangs indefinitely
**Investigation**: 3 hours of diagnostics completed
**Handoff**: See `INVESTIGATION_REPORT.md` for complete diagnostic timeline

### What We Know
- ✅ Certificate **expired** (confirmed in admin console)
- ✅ MagicDNS **enabled**
- ✅ HTTPS **enabled** in tailnet
- ✅ Daemon **running** and **online**
- ❌ Certificate renewal **hangs** (Let's Encrypt communication failure)
- ❌ TLS handshake **times out** (no valid cert available)

### 🚨 CRITICAL NEW CONTEXT
**Device recently migrated**: App Store Tailscale → standalone version
- Process assigned NEW device ID, NEW IP, NEW domain
- User manually changed NEW device to match old IP/domain (100.102.226.62, mneme-macbook-pro14)
- Certificate provisioning broken since migration
- **Hypothesis**: Orphaned certificate state from old device identity blocking new provisioning

### Next Steps (UPDATED)
See `INVESTIGATION_REPORT.md` for detailed diagnostic plan. **START WITH PRIORITY 0** (migration state cleanup):

**Priority 0** (HIGHEST): Investigate orphaned certificate state from migration
1. Check local ACME state files (`/Library/Tailscale/`)
2. Test cert provisioning with completely fresh domain name
3. Query Tailscale API for old device certificate state
4. Consider fresh device logout/login to get clean identity

**Priority 1-4**: If Priority 0 doesn't resolve:
1. Test Let's Encrypt connectivity
2. Verify system time accuracy
3. Enable debug logging
4. Check DNS TXT record creation

**See**: `INVESTIGATION_REPORT.md` for complete handoff documentation with migration context.

---

## Problem Summary (Original)

- Tailscale Serve is configured on mneme to proxy `http://127.0.0.1:18080`.
- OpenVSCode is reachable on mneme locally (HTML returned from `curl http://127.0.0.1:18080`).
- From eos/phone, `curl https://mneme-macbook-pro14.ayu-scylla.ts.net/` fails with TLS error:
  `LibreSSL/3.3.6: error:1404B438:SSL routines:ST_CONNECT:tlsv1 alert internal error`.
- `tailscale ping` and `ssh` to mneme work.

---

## Diagnostic Results

### ✅ What Works

1. **Tailscale Daemon**: Running and online
   ```bash
   $ tailscale status --json | jq -r '.BackendState,.Self.Online'
   Running
   true
   ```

2. **Serve Configuration**: Properly configured
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

3. **Port 443 Listener**: Active (system extension level)
   ```bash
   $ netstat -an | grep "\.443.*LISTEN"
   tcp4       0      0  *.443                  *.*                    LISTEN
   tcp6       0      0  *.443                  *.*                    LISTEN
   ```

4. **Backend Service**: OpenVSCode responding on `http://127.0.0.1:18080`
   ```bash
   $ curl -s http://127.0.0.1:18080 | head -5
   <!-- Copyright (C) Microsoft Corporation. All rights reserved. -->
   <!DOCTYPE html>
   <html>
   ...
   ```

### ❌ What Fails

1. **TLS Handshake**: Times out after 60 seconds
   ```bash
   $ curl -vk https://mneme-macbook-pro14.ayu-scylla.ts.net/
   * Connected to mneme-macbook-pro14.ayu-scylla.ts.net (100.102.226.62) port 443
   * ALPN: curl offers h2,http/1.1
   * (304) (OUT), TLS handshake, Client hello (1):
   [60 second timeout...]
   * LibreSSL/3.3.6: error:1404B438:SSL routines:ST_CONNECT:tlsv1 alert internal error
   curl: (35) LibreSSL/3.3.6: error:1404B438:SSL routines:ST_CONNECT:tlsv1 alert internal error
   ```

2. **Certificate Provisioning**: Hangs indefinitely
   ```bash
   $ tailscale cert mneme-macbook-pro14.ayu-scylla.ts.net
   [hangs forever - cannot obtain certificate]
   ```

---

## Root Cause Analysis

### Problem Chain

1. ✅ Configuration exists → `tailscale serve status` shows correct config
2. ✅ Listener active → Port 443 listening (netstat confirms)
3. ✅ Backend working → OpenVSCode responds locally
4. ❌ **TLS fails** → Handshake times out, cannot complete

### Why TLS Fails

**Critical Requirement**: Tailscale Serve requires **HTTPS to be enabled in the Tailnet** for automatic TLS certificate provisioning ([source](https://tailscale.com/kb/1312/serve)).

**Without HTTPS enabled**:
- ✅ `tailscale serve` command accepts configuration
- ✅ Port 443 listener starts (network extension level)
- ✅ Connections accepted
- ❌ **No TLS certificate available** → handshake cannot complete
- ❌ Connection times out after 60s
- ❌ Client sees: `tlsv1 alert internal error`

---

## Lessons Learned

### 1. `lsof` Limitations
- **Problem**: `lsof -iTCP:443 -sTCP:LISTEN` returned nothing
- **Why**: Tailscale uses a system extension (kernel-level listener), not user-space process
- **Fix**: Use `netstat -an | grep 443` for comprehensive port listing

### 2. Configuration ≠ Working Service
- **Problem**: `tailscale serve status` showing config doesn't mean HTTPS works
- **Lesson**: Must verify TLS handshake actually completes
- **Diagnostic**: `curl -vk https://[device].ts.net/` to test end-to-end

### 3. Certificate Provisioning Check
- **Problem**: Assumed HTTPS was enabled without verifying
- **Diagnostic**: `tailscale cert [device].ts.net` should complete in <5 seconds
- **If it hangs**: HTTPS not enabled in Tailnet

### 4. Initial Hypothesis Validation
- **Original theory**: GUI app not running → **Incorrect**
- **Evidence**: Process check showed both app and extension running
- **Lesson**: Don't assume initial hypothesis is correct; follow evidence

---

## Next Steps (User Action Required)

### 1. Enable HTTPS in Tailnet
**URL**: https://login.tailscale.com/admin/dns
**Action**: Enable "HTTPS Certificates"
**Wait**: 1-2 minutes for initialization

### 2. Reset and Recreate Serve
**On mneme (local terminal)**:
```bash
/Applications/Tailscale.app/Contents/MacOS/tailscale serve reset
/Applications/Tailscale.app/Contents/MacOS/tailscale serve --bg 18080
```

### 3. Verify Certificate
```bash
/Applications/Tailscale.app/Contents/MacOS/tailscale cert mneme-macbook-pro14.ayu-scylla.ts.net
# Should complete in <5 seconds and write .crt and .key files
```

### 4. Test HTTPS Connection
**From eos/phone**:
```bash
curl -vk https://mneme-macbook-pro14.ayu-scylla.ts.net/
# Should return OpenVSCode HTML (200 OK)
```

---

## Documentation Updates (After User Confirms Fix)

### Files to Update

1. **`comme-ca/DOCS/DEVPOD_REMOTE_PLAYBOOK.md`**
   - Add troubleshooting section for Tailscale Serve TLS errors
   - Add diagnostic commands (netstat, tailscale cert check)

2. **`comme-ci/docs/devpod-host-setup.md`**
   - Strengthen HTTPS prerequisite warning (line 39)
   - Add troubleshooting section for TLS errors

3. **`SPECS/bug-tailscale-serve-devpod/_ENTRYPOINT.md`**
   - Update status to ✅ RESOLVED
   - Add lessons learned section

---

## References

- [Tailscale Serve KB](https://tailscale.com/kb/1242/tailscale-serve)
- [Tailscale HTTPS KB](https://tailscale.com/kb/1312/serve)
- [Tailscale Services KB](https://tailscale.com/kb/1552/tailscale-services)
- **Resolution doc**: `RESOLUTION.md` (full diagnostic timeline)

---

## Context Acquisition (Completed)

### comme-ca
- ✅ `AGENTS.md`
- ✅ `README.md`
- ✅ `REQUIREMENTS.md`
- ✅ `DESIGN.md`
- ✅ `_ENTRYPOINT.md`
- ✅ `DOCS/DEVPOD_REMOTE_PLAYBOOK.md`

### comme-ci (chezmoi)
- ✅ `AGENTS.md`
- ✅ `README.md`
- ✅ `requirements.md`
- ✅ `design.md`
- ✅ `_ENTRYPOINT.md`
- ✅ `docs/devpod-host-setup.md`

### fahn-lai-bun
- ✅ `AGENTS.md`
- ✅ `README.md`
- ✅ `requirements.md`
- ✅ `design.md`
- ✅ `_ENTRYPOINT.md`

### Research
- ✅ Perplexity search: Tailscale Serve + macOS listener issues
- ✅ Diagnostic commands executed on mneme
- ✅ TLS connection tests from mneme (simulating eos)
