# ENTRYPOINT (HANDOFF)

> **READ FIRST:** This file contains the critical context, recent changes, and immediate directives for the next agent or developer working on this repository.

## 1. The Situation
**Phase:** Debugging & Ecosystem Hardening.
We are addressing two critical issues:
1.  **Agent Interactive Hangup:** Agents get stuck in `cca audit` calls.
2.  **Missing API Keys:** Gemini CLI and other tools lacked access to Tavily/Perplexity keys due to missing exports in `fish` config.

## 2. Recent Actions
*   **Documentation Sync:** Backported `AGENTS.md` from `chezmoi` to `comme-ca`.
*   **Wrap Protocol:** Hardened `pass.md` to enforce `git push`.
*   **Debugging `cca`:**
    *   Updated `bin/cca` to use `claude -p` (print mode) and `--dangerously-skip-permissions`.
    *   Added logic to append user input to role prompts.
    *   **Status:** `cca git` works. `cca audit` hangs.
*   **Fixing Secrets:**
    *   Identified `00-gx-secrets.fish.tmpl` was missing `TAVILY_API_KEY`, `PERPLEXITY_API_KEY`, `EXA_API_KEY`, `CONTEXT7_API_KEY`.
    *   **FIXED:** Updated template and ran `chezmoi apply`. Shell reload required.

## 3. Critical Blockers
1.  **Interactive Hangup:** `cca audit "sanity check"` still hangs.
    *   **Root Cause:** `claude` CLI permission prompts or input handling on closed stdin.
    *   **Next Step:** Research `claude` CLI non-interactive behavior (requires working search).
2.  **Broken Tooling:** My (Gemini CLI) MCP tools (Tavily, Perplexity) are broken in *current* session due to missing env vars.
    *   **Workaround:** Use `google_web_search`.
    *   **Fix:** Restart session (shell) to pick up new `fish` secrets.

## 4. System Capabilities
*   **Unified Search:** `cca search` (abbreviated `?`) launches the interactive agent.
*   **Agent Roles:** Standard roles (`/prep`, `/plan`, `/audit`, `/wrap`) defined in `AGENTS.md`.
*   **CLI Wrapper:** `bin/cca` provides the unified interface.

## 5. Troubleshooting Guide

### "cca command not found"
**Likely Cause:** `bin/` not in PATH.
**Fix:**
```bash
export PATH="$HOME/dev/comme-ca/bin:$PATH"
```

### "Drift detected in AGENTS.md"
**Likely Cause:** Updates in `chezmoi` haven't been backported.
**Fix:**
```bash
cp ~/.local/share/chezmoi/AGENTS.md ~/dev/comme-ca/AGENTS.md
```

## 6. Next Orders (Immediate Handoff)

1.  **Restart Session:** The user/agent needs to reload shell or restart to pick up `TAVILY_API_KEY` etc.
2.  **Research Root Cause:** With working keys, use Perplexity/Tavily to investigate `claude` CLI non-interactive behavior.
3.  **Fix `cca` Wrapper:** Implement robust `claude` invocation (timeout, flags).
4.  **Backport Shell Portability:** (Pending).

## 7. Key References
*   `@specs/active/agent-interactive-safety.md` - Spec for the safety protocol.
*   `@bin/cca` - The wrapper script under investigation.
*   `@~/.config/fish/conf.d/00-gx-secrets.fish` - Source of truth for secrets.

---
**Last Updated:** 2025-12-17
**Phase:** Debugging / Hardening
