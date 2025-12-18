# ENTRYPOINT (HANDOFF)

> **READ FIRST:** This file contains the critical context, recent changes, and immediate directives for the next agent or developer working on this repository.

## 1. The Situation
**Phase:** Feature Complete & Operational.
We have successfully implemented the **Search Agent** (`cca search`) and resolved the ecosystem deployment blockers. The system is now healthy and ready for broader adoption.

## 2. Recent Actions
*   **Search Agent:** Implemented `cca search` in `bin/cca` and verified deployment via `chezmoi`.
*   **Prompt Port:** Ported prompts to `prompts/search_agents/`.
*   **Deployment Fix:** Resolved `chezmoi` bootstrapping issues in `comme-ci`, ensuring `cca search` abbreviations (`?`, `,`) are correctly deployed.
*   **Configuration:** Updated `AGENTS.md` abbreviations.
*   **Documentation Sync:** Backported `AGENTS.md` from `chezmoi` (Governor) to `comme-ca` (Distro) to resolve drift.
*   **Hardening:** Updated `prompts/roles/pass.md` to explicitly enforce `git push` during the wrap protocol.

## 3. System Capabilities
*   **Unified Search:** `cca search` (abbreviated `?`) launches the interactive agent.
*   **Agent Roles:** Standard roles (`/prep`, `/plan`, `/audit`, `/wrap`) defined in `AGENTS.md`.
*   **CLI Wrapper:** `bin/cca` provides the unified interface.

## 4. Manual Testing Checklist
Run these tests to verify the Distro's health.

### Test 1: Search Agent
```bash
bin/cca search --interactive "What is the capital of France?"
```
**Expected:** Agent launches, thinks, and responds correctly.

### Test 2: Role Prompt Loading
```bash
bin/cca git "status"
```
**Expected:** `cca` wrapper executes the git command via the LLM (or directly if configured).

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

1.  **Backport Shell Portability:** The Ecosystem Audit identified that "Shell Portability" directives are present in Distro (`comme-ca`) but missing from Lab (`comment-dit-on`). This needs to be backported to maintain the "Lab -> Distro" flow.
2.  **Lab Cleanup:** Verify if Lab (`comment-dit-on`) has renamed `AGENTS.md` to `SEARCH_AGENT_GUIDE.md` to resolve the semantic collision.
3.  **Search Agent Polish:** Monitor usage of `cca search` for any edge cases in the interactive mode.

## 7. Key References
*   `@specs/search-agent/spec.md` - Search Agent Specification.
*   `@bin/cca` - The implementation.
*   `@prompts/search_agents/` - Search prompt definitions.

---
**Last Updated:** 2025-12-17
**Phase:** Feature Complete / Operational
