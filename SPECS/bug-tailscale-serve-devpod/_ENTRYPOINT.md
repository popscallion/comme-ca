<!--
@id: bug-tailscale-serve-devpod-entrypoint
@version: 0.1.0
@model: codex
-->
# Iteration Dashboard: Tailscale Serve + DevPod OpenVSCode

| Status | Description | Owner |
| :--- | :--- | :--- |
| **Active** | Serve endpoint not reachable from eos/phone | Next Agent |

## Problem Summary
- Tailscale Serve is configured on mneme to proxy `http://127.0.0.1:18080`.
- OpenVSCode is reachable on mneme locally (HTML returned from `curl http://127.0.0.1:18080`).
- From eos/phone, `curl https://mneme-macbook-pro14.ayu-scylla.ts.net/` fails with TLS error:
  `LibreSSL/3.3.6: error:1404B438:SSL routines:ST_CONNECT:tlsv1 alert internal error`.
- `tailscale ping` and `ssh` to mneme work.

## Key Findings
- OpenVSCode listens on port 10800 inside workspace.
- Successful tunnel on mneme:
  `ssh fahn-lai-bun-mneme-vm.devpod -L 18080:127.0.0.1:10800 -N`
- `tailscale serve status --json` shows a proxy on 443 to 127.0.0.1:18080.
- `lsof -iTCP:443 -sTCP:LISTEN` on mneme showed no listener (unexpected for Serve).

## Hypotheses
- Serve is configured but not actually binding on 443 due to GUI/session constraints or a macOS firewall rule.
- TLS handshake error indicates Serve isn’t terminating TLS properly or not reachable from tailnet due to ACL or firewall.
- Tailscale app/daemon may be running but Serve not active as a listener.

## Immediate Next Steps
1. Validate Serve listener on mneme:
   - `lsof -iTCP:443 -sTCP:LISTEN`
   - `sudo lsof -iTCP:443 -sTCP:LISTEN` (if needed)
2. Check Tailscale Serve status and logs:
   - `tailscale serve status --json`
   - `tailscale status --json | jq -r .BackendState,.Self.Online`
   - `log stream --predicate 'process == "Tailscale"' --info --last 5m`
3. Confirm firewall behavior on mneme:
   - `sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate`
   - Check if Tailscale app is allowed for incoming connections.
4. Recreate Serve config:
   - `tailscale serve reset`
   - `tailscale serve --bg 18080`
   - Then re-test from eos with `curl -vk https://mneme-macbook-pro14.ayu-scylla.ts.net/`
5. If Serve is blocked, try `tailscale serve --https=443 off` and `tailscale serve --https 443 --bg 18080` to rebind.

## Context Acquisition (MANDATORY)
Read these files before changes:

### comme-ca
- `AGENTS.md`
- `README.md`
- `REQUIREMENTS.md`
- `DESIGN.md`
- `_ENTRYPOINT.md`
- `DOCS/DEVPOD_REMOTE_PLAYBOOK.md`

### comme-ci (chezmoi)
- `AGENTS.md`
- `README.md`
- `requirements.md`
- `design.md`
- `_ENTRYPOINT.md`
- `docs/devpod-host-setup.md`

### fahn-lai-bun (sfs branch)
- `AGENTS.md`
- `README.md`
- `requirements.md`
- `design.md`
- `_ENTRYPOINT.md`

## Required MCP + curl checks
- Use MCP tools to search Tailscale Serve + macOS listener issues.
- Run from eos:
  - `curl -vk https://mneme-macbook-pro14.ayu-scylla.ts.net/`
  - Capture TLS error output for the report.

## Output Required
- Root cause hypothesis
- Exact commands run + outputs
- Concrete fix (or next narrowing steps)
