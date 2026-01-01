# ENTRYPOINT (Iteration Dashboard)

**New Active Handoff:** `SPECS/bug-tailscale-serve-devpod/_ENTRYPOINT.md` (Serve endpoint TLS failure)

## Current Status
We are in **Phase 3** (Protocol Synchronization & Rollout).
We have successfully implemented **Agentic Abstractions** (Agents/Subagents/Skills) and the **Protocol Sync** architecture (Registry/Shim/Harvest).

## 1. The Situation
The `comme-ca` system has evolved from a static template generator to a synchronized protocol.
- **Protocol Registry:** Located at `~/.comme-ca/protocol/dev`.
- **Shim Pattern:** New projects reference core docs instead of copying them.
- **Two-Way Sync:** `mise` patches downstream projects; `tune` harvests downstream improvements.

## Inbox Rule (Non‑Negotiable)
If `_INBOX/` has contents, pause all work and triage interactively:
- Create or select a spec in `SPECS/`.
- Append raw text to `SPECS/<spec>/_RAW/RAW.md` (date heading if possible).
- Move non‑text artifacts to `SPECS/<spec>/_RAW/assets/` and reference them in `RAW.md`.

## Completion Rule (Spec Cleanup)
If a spec is marked completed (root `_ENTRYPOINT.md` or spec `_ENTRYPOINT.md`) but still exists in `SPECS/`:
- Synthesize outcomes into `DOCS/` or root docs (single source of truth).
- Archive chat to `SPECS/_ARCHIVE/chat-<spec-slug>.md`.
- Remove the spec directory from `SPECS/` (including `_RAW/assets/`).
- Missing date stamps in `RAW.md` must not block completion.

## Downstream Upgrade Protocol (Existing Projects)
Use this to bring existing comme‑ca projects up to the new `DOCS/` + `SPECS/` conventions.

### Preferred: Run `prep` (Mise) in the downstream repo
**Prompt to agent (copy/paste):**
```
prep: Upgrade this repo to current comme-ca conventions.
Tasks:
1) Rename docs/ -> DOCS/ and specs/ -> SPECS/ using git mv (case-only rename safe path).
2) Ensure _INBOX/, DOCS/, SPECS/, and SPECS/_ARCHIVE/ exist.
3) Update all references from docs/ and specs/ to DOCS/ and SPECS/.
4) If _INBOX contains files, triage into SPECS/<spec>/_RAW/RAW.md (append-only; date heading if possible) and _RAW/assets/.
5) If any spec is marked completed, synthesize into DOCS/ or root docs, archive chat to SPECS/_ARCHIVE/chat-<spec>.md, and remove SPECS/<spec>/.
6) Update _ENTRYPOINT.md to include Inbox Rule and Completion Rule if missing.
7) Run a repo-wide scan for old `docs/` or `specs/` references and report any remaining hits.
Report manual conflicts or ambiguous triage items before changing them.
```

**Manual checks:**
- Verify `DOCS/` contains project docs (move from old `docs/` if needed).
- Verify `SPECS/_ARCHIVE/` contains only `chat-<spec>.md` for completed specs.
- Confirm `RAW.md` is append‑only and assets are referenced.
- Run: `rg -n "\\bdocs/|\\bspecs/" -g "*"`, then fix any remaining lowercase references.

### Secondary: Run `tune` (Audit/Reflection) if drift persists
**Prompt to agent (copy/paste):**
```
tune: Identify any remaining drift from current comme-ca conventions.
Focus:
- Missing DOCS/ or SPECS/ directories.
- Old references to docs/ or specs/.
- Completed specs still present in SPECS/.
- _INBOX not empty or not triaged into RAW.md.
Provide a concise remediation list.
```

## 2. Testing Gate (MANDATORY BEFORE ANY NEW WORK)
**Status:** Not yet verified since the DOCS/SPECS and inbox workflow changes.  
**Rule:** Do **not** start new work in `comme-ca` until these tests are run **or** the user explicitly defers them.

### Required Test Run
```bash
# 1. Sync local registry
cca setup:sync

# 2. Test new scaffolding (Shim + DOCS/SPECS/_INBOX)
mkdir -p ~/tmp/shim-test && cd ~/tmp/shim-test
cca init
ls -a
cat AGENTS.md  # Should show @import directive

# 3. Verify structure
# - DOCS/, SPECS/, _INBOX/ exist
# - REQUIREMENTS.md and DESIGN.md at root (not inside SPECS/)
```

### If Tests Were Not Run
Stop and prompt the user:
> “We need to run the required tests before continuing. Run them now, or explicitly defer?”

### Testing Status
Deferred (2025-12-27 14:26). Do not proceed with new work until tests are run or explicitly deferred again.

---

## 3. Active Specs
| Spec | Status | Focus |
|:-----|:-------|:------|
| `feature-mcp-redo` | 🟡 Active | Filesystem Discovery logic |

## 4. Recent Changes
- Added default-on DevPod/Ona container scaffold to `cca init` with opt-out flag `--no-container`.
- Added flags `--init-git` (initialize repo and install hooks) and `--force` (apply scaffold on conflict).
- Added flow documentation at `DOCS/CCA_INIT.md` and archived the spec at `SPECS/_ARCHIVE/chat-feature-cca-devpod-scaffold.md`.
- Dry run verified on 2025-12-31 in `~/tmp/cca-init-test`.

## 5. Roadmap (Short-Term)
- See `DOCS/CCA_INIT.md` and `DOCS/DEVPOD_REMOTE_PLAYBOOK.md` for current DevPod scaffolding guidance.

## 6. Troubleshooting (Scaffold Iteration)
- If `cca init` detects conflicts, re-run with `--force` to apply the DevPod scaffold.
- If you do not want container defaults, re-run with `--no-container`.
- If `.git/` is missing and you want hooks, re-run with `--init-git`.
- If `devcontainer.json` is malformed, fix the JSON or delete `.devcontainer/devcontainer.json` and re-run `cca init`.
- Phone workflows require running the DevPod CLI on an always-on client so ports bind there.

---
**Last Updated:** 2025-12-27 14:22
**Previous:** Archived completed specs (protocol sync, search agent, pass, strict conventions)
