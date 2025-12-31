<!--
@id: devpod-remote-playbook
@version: 0.1.0
@model: codex
-->
# DevPod Remote Playbook (Portable)

## Scope
This document describes a host-agnostic workflow for DevPod remote sessions. It avoids user-specific hosts, secrets, and hardware details. Those belong in comme-ci/chezmoi or project repos.

## Quickstart (Portable)
```bash
devpod provider add ssh --name <provider-name> --option HOST=<ssh-alias>
devpod up <repo-url> --provider <provider-name> --id <repo>-<host> --ide none
devpod ssh <repo>-<host> --command "cd /workspaces/<repo>-<host> && git pull --ff-only"
devpod ssh <repo>-<host> -- -L 5173:127.0.0.1:5173
```

## 1) Provider setup (per host)
1. Create an SSH alias in `~/.ssh/config` for the remote host.
2. Add a DevPod provider:
   ```bash
   devpod provider add ssh --name <provider-name> --option HOST=<ssh-alias>
   ```

## 2) Workspace creation (per project)
Use Git URL flow for portability:
```bash
 devpod up <repo-url> --provider <provider-name> --id <repo>-<host> --ide none
```

## 3) Connect + update
```bash
 devpod ssh <repo>-<host> --command "cd /workspaces/<repo>-<host> && git pull --ff-only"
```

## 4) Port forwarding (dev server)
```bash
 devpod ssh <repo>-<host> -- -L 5173:127.0.0.1:5173
```

## 5) Browser IDE (optional)
Use OpenVSCode when you need a browser IDE:
```bash
 devpod ide use openvscode
 devpod ide set-options -o BIND_ADDRESS=127.0.0.1:18080 -o OPEN=false
 devpod up <repo-url> --provider <provider-name> --id <repo>-<host> --ide openvscode
 devpod ssh <repo>-<host> -- -L 18080:127.0.0.1:18080
```

## 6) Tailnet access (phone-friendly)
Forward OpenVSCode to localhost, then expose it via Tailscale Serve:
```bash
 tailscale serve --bg 18080
```
Use Tailscale Funnel only if you need public access.

## 7) Cleanup
```bash
 devpod stop <repo>-<host>
 devpod delete <repo>-<host> --force
```
