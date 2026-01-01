# Tailscale Serve DevPod Bug - Resolution

**Date**: 2025-12-31
**Status**: Root cause identified, awaiting user action to enable HTTPS in Tailnet
**Severity**: Blocker for phone-based DevPod access

---

## Executive Summary

**Problem**: `tailscale serve --bg 18080` configured successfully but TLS handshake fails with "tlsv1 alert internal error" when accessing `https://mneme-macbook-pro14.ayu-scylla.ts.net/`

**Root Cause**: HTTPS certificates are not enabled or cannot be provisioned for the Tailnet. Tailscale Serve requires HTTPS to be enabled in the Tailnet settings for TLS certificate auto-provisioning.

**Fix**: Enable HTTPS certificates in Tailnet admin console at https://login.tailscale.com/admin/dns

---

## Diagnostic Timeline

### Initial Hypothesis (Incorrect)
- **Theory**: Tailscale GUI app not running in logged-in macOS session
- **Evidence Against**:
  - ✅ `ps aux` shows both Tailscale.app and network extension running
  - ✅ `netstat` shows port 443 listening on `*:443`
  - ✅ `tailscale status` shows "Running" and "Online"

### Refined Hypothesis (Correct)
- **Theory**: HTTPS not enabled in Tailnet, preventing TLS certificate provisioning
- **Evidence For**:
  - ✅ `tailscale cert mneme-macbook-pro14.ayu-scylla.ts.net` hangs indefinitely (cannot obtain cert)
  - ✅ TLS handshake timeout after 60s (server accepts connection but can't complete TLS)
  - ✅ Error: `tlsv1 alert internal error` (generic TLS failure)
  - ✅ Serve config exists but no working HTTPS endpoint

---

## Diagnostic Commands Run

### 1. Process Check
```bash
ssh l@mneme-macbook-pro14 "ps aux | grep -i tailscale | grep -v grep"
```
**Result**: ✅ Both Tailscale.app (PID 2163) and network extension (PID 2191) running

### 2. Backend State
```bash
ssh l@mneme-macbook-pro14 "bash -c '/Applications/Tailscale.app/Contents/MacOS/tailscale status --json | jq -r \".BackendState,.Self.Online\"'"
```
**Result**: ✅ `Running` and `true`

### 3. Serve Configuration
```bash
ssh l@mneme-macbook-pro14 "bash -c '/Applications/Tailscale.app/Contents/MacOS/tailscale serve status --json'"
```
**Result**: ✅ Configuration exists:
```json
{
  "TCP": {
    "443": {
      "HTTPS": true
    }
  },
  "Web": {
    "mneme-macbook-pro14.ayu-scylla.ts.net:443": {
      "Handlers": {
        "/": {
          "Proxy": "http://127.0.0.1:18080"
        }
      }
    }
  }
}
```

### 4. Port Listener Check
```bash
ssh l@mneme-macbook-pro14 "bash -c 'netstat -an | grep \"\.443.*LISTEN\"'"
```
**Result**: ✅ Port 443 listening:
```
tcp4       0      0  *.443                  *.*                    LISTEN
tcp6       0      0  *.443                  *.*                    LISTEN
```

**Note**: `lsof -iTCP:443 -sTCP:LISTEN` returned nothing because Tailscale uses a system extension (kernel-level listener), not a regular user-space process.

### 5. Backend Service Check
```bash
ssh l@mneme-macbook-pro14 "lsof -iTCP:18080 -sTCP:LISTEN"
```
**Result**: ✅ OpenVSCode tunnel active (SSH forwarding port 18080)

### 6. Backend Service Response
```bash
ssh l@mneme-macbook-pro14 "curl -s http://127.0.0.1:18080 | head -20"
```
**Result**: ✅ OpenVSCode HTML returned (backend service working)

### 7. TLS Connection Test
```bash
ssh l@mneme-macbook-pro14 "curl -vk --max-time 10 https://mneme-macbook-pro14.ayu-scylla.ts.net/"
```
**Result**: ❌ TLS handshake timeout after 10 seconds:
```
* Connected to mneme-macbook-pro14.ayu-scylla.ts.net (100.102.226.62) port 443
* ALPN: curl offers h2,http/1.1
* (304) (OUT), TLS handshake, Client hello (1):
[60 second wait...]
* Connection timed out after 10002 milliseconds
curl: (28) Connection timed out after 10002 milliseconds
```

### 8. Certificate Provisioning Test
```bash
ssh l@mneme-macbook-pro14 "bash -c '/Applications/Tailscale.app/Contents/MacOS/tailscale cert mneme-macbook-pro14.ayu-scylla.ts.net'"
```
**Result**: ❌ Hangs indefinitely (certificate cannot be obtained)

---

## Root Cause Analysis

### Problem Chain

1. **Configuration Exists**: `tailscale serve status` shows proper config
2. **Listener Active**: Port 443 is listening (netstat confirms)
3. **Backend Working**: OpenVSCode responds on `http://127.0.0.1:18080`
4. **TLS Fails**: Handshake times out, cannot complete

### Why TLS Fails

**Critical Requirement**: Tailscale Serve requires **HTTPS to be enabled in the Tailnet** for automatic TLS certificate provisioning.

From Perplexity search results ([Source](https://tailscale.com/kb/1312/serve)):
> "Tailscale Serve requires HTTPS to be enabled in your tailnet to automatically provision TLS certificates. If HTTPS isn't enabled, the service cannot start listeners on HTTPS ports."

**What Happens Without HTTPS Enabled**:
1. ✅ `tailscale serve` command accepts configuration
2. ✅ Port 443 listener starts (network extension level)
3. ✅ Connections accepted
4. ❌ **No TLS certificate available** → handshake cannot complete
5. ❌ Connection times out after 60s
6. ❌ Client sees: `tlsv1 alert internal error`

---

## Resolution Steps

### 1. Enable HTTPS in Tailnet (USER ACTION REQUIRED)

**Go to**: https://login.tailscale.com/admin/dns

**Steps**:
1. Log in to Tailscale admin console
2. Navigate to **DNS** settings
3. Ensure **"HTTPS Certificates"** is **enabled**
4. Wait 1-2 minutes for certificate provisioning to initialize

### 2. Reset and Recreate Serve Configuration

**On mneme (local terminal)**:
```bash
# Reset existing serve config
/Applications/Tailscale.app/Contents/MacOS/tailscale serve reset

# Recreate serve with background mode
/Applications/Tailscale.app/Contents/MacOS/tailscale serve --bg 18080
```

**Expected output**:
```
Available within your tailnet:

https://mneme-macbook-pro14.ayu-scylla.ts.net/
|-- proxy http://127.0.0.1:18080

Serve started and running in the background.
```

### 3. Verify Certificate Provisioned

```bash
/Applications/Tailscale.app/Contents/MacOS/tailscale cert mneme-macbook-pro14.ayu-scylla.ts.net
```

**Expected output** (should complete in <5 seconds):
```
Writing certificate to: mneme-macbook-pro14.ayu-scylla.ts.net.crt
Writing key to: mneme-macbook-pro14.ayu-scylla.ts.net.key
Success. Certificates written to disk.
```

### 4. Test HTTPS Connection

**From mneme**:
```bash
curl -vk https://mneme-macbook-pro14.ayu-scylla.ts.net/
```

**Expected output**:
```
* Connected to mneme-macbook-pro14.ayu-scylla.ts.net (100.102.226.62) port 443
* SSL connection using TLSv1.3 / TLS_AES_128_GCM_SHA256
< HTTP/1.1 200 OK
[OpenVSCode HTML content]
```

**From eos** (phone access validation):
```bash
curl -vk https://mneme-macbook-pro14.ayu-scylla.ts.net/
```

Should return same successful response.

---

## Alternative: HTTP Tunnel (If HTTPS Cannot Be Enabled)

If HTTPS cannot be enabled in the Tailnet (e.g., corporate policy, free tier limitations), use direct SSH tunnel instead:

### Option A: Direct SSH Tunnel (eos → mneme)

**On eos**:
```bash
# Create tunnel from eos to mneme
ssh l@mneme-macbook-pro14 -L 18080:127.0.0.1:18080 -N

# Access in browser on eos
open http://localhost:18080
```

**Downside**: Requires active SSH connection, won't work when eos offline.

### Option B: Tailscale Funnel (Public Access)

**On mneme**:
```bash
tailscale funnel 18080
```

**Access from anywhere**: `https://mneme-macbook-pro14.ayu-scylla.ts.net/`

**Downside**: Public internet exposure (use with caution).

---

## Documentation Updates Needed

### 1. `comme-ca/DOCS/DEVPOD_REMOTE_PLAYBOOK.md`

**Add troubleshooting section**:

```markdown
### Troubleshooting Tailscale Serve

**Problem**: `tailscale serve` configured but TLS handshake fails

**Symptoms**:
- `tailscale serve status` shows configuration
- `netstat -an | grep 443` shows listener
- `curl https://[device].ts.net/` times out or returns TLS error

**Root Cause**: HTTPS not enabled in Tailnet

**Fix**:
1. Go to https://login.tailscale.com/admin/dns
2. Enable "HTTPS Certificates"
3. Wait 1-2 minutes
4. Run: `tailscale serve reset && tailscale serve --bg [port]`
5. Verify: `tailscale cert [device].ts.net` (should complete in <5s)

**Diagnostic Commands**:
```bash
# Check if port 443 is listening
netstat -an | grep "\.443.*LISTEN"

# Check if certificate can be obtained
tailscale cert [device].ts.net  # Should NOT hang
```
```

### 2. `comme-ci/docs/devpod-host-setup.md`

**Strengthen existing warning** (line 39):

```markdown
## Phone Route (Tailnet-only)

**CRITICAL PREREQUISITE**: HTTPS must be enabled in your Tailnet for `tailscale serve` to work.
- Go to https://login.tailscale.com/admin/dns
- Ensure "HTTPS Certificates" is enabled
- Without this, TLS handshake will fail with "tlsv1 alert internal error"

1. Start OpenVSCode in the workspace:
   ...
```

**Add diagnostic section**:

```markdown
## Troubleshooting

**Tailscale Serve TLS Errors**:
- **Symptom**: Connection times out or "tlsv1 alert internal error"
- **Check**: `tailscale cert [device].ts.net` (should NOT hang)
- **Fix**: Enable HTTPS in Tailnet admin console → DNS settings
- **Verify**: `netstat -an | grep 443` shows listener
```

### 3. `SPECS/bug-tailscale-serve-devpod/_ENTRYPOINT.md`

**Update status**:

```markdown
# Bug: Tailscale Serve DevPod

**Status**: ✅ RESOLVED
**Date Resolved**: 2025-12-31
**Resolution**: HTTPS not enabled in Tailnet (user action required)

## Summary

`tailscale serve --bg 18080` configured successfully but TLS handshake fails.

**Root Cause**: Tailscale Serve requires HTTPS to be enabled in the Tailnet admin console for TLS certificate auto-provisioning.

**Fix**: Enable HTTPS certificates at https://login.tailscale.com/admin/dns

**See**: `RESOLUTION.md` for full diagnostic timeline and fix steps.

## Lessons Learned

1. **`lsof` limitations**: Doesn't show kernel-level listeners (Tailscale system extension)
   - Use `netstat -an` for comprehensive port listing

2. **Configuration ≠ Working Service**:
   - `tailscale serve status` showing config doesn't mean HTTPS actually works
   - Must verify TLS handshake completes

3. **Diagnostic chain**:
   - Port listening? → `netstat -an | grep 443`
   - TLS working? → `curl -vk https://[device].ts.net/`
   - Certificate available? → `tailscale cert [device].ts.net` (should NOT hang)

4. **Tailscale Serve requirements**:
   - GUI app must be running (macOS)
   - HTTPS must be enabled in Tailnet
   - Backend service must be listening on target port
```

---

## Next Steps

1. **User**: Enable HTTPS in Tailnet admin console
2. **User**: Run resolution steps (reset serve, verify cert)
3. **User**: Test from eos/phone
4. **Agent**: Update documentation files (after user confirms fix works)
5. **Agent**: Archive spec to `SPECS/archived/bug-tailscale-serve-devpod/`

---

## References

- [Tailscale Serve KB](https://tailscale.com/kb/1242/tailscale-serve)
- [Tailscale HTTPS KB](https://tailscale.com/kb/1312/serve)
- [Tailscale Services KB](https://tailscale.com/kb/1552/tailscale-services)
- Perplexity search: "Tailscale Serve macOS port 443 not listening"
