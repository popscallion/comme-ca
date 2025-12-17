# ENTRYPOINT (HANDOFF)

> **READ FIRST:** This file contains the critical context, recent changes, and immediate directives for the next agent or developer working on this repository.

## 1. The Situation
**Phase:** Feature Completion & Ecosystem Remediation.
We have successfully implemented the **Search Agent** (`cca search`) and remediated the **Ecosystem Audit** findings across all three repositories (Lab, Distro, Consumer).

## 2. Recent Actions
*   **Search Agent:** Implemented `cca search` in `bin/cca` with wrapper-managed state (session persistence).
*   **Prompt Port:** Ported `haiku45.md` and `cerebras-120b.md` from Lab to Distro via updated `bin/sync-prompts`.
*   **Lab Fixes:** Renamed Lab `AGENTS.md` → `SEARCH_AGENT_GUIDE.md` to avoid semantic collision. Created new Lab `AGENTS.md` (Standard Orchestration).
*   **Distro Fixes:** Added `?` and `,` abbreviations to `AGENTS.md`. Updated `README.md`.
*   **Docs:** Extracted Chezmoi MCP docs to `docs/mcp-management.md`. Fixed Larval protocol link.

## 3. Manual Verification (User)
You should manually verify the new Search Agent capabilities:
1.  **Single Shot:** `cca search "What is the latest context7 version?"`
2.  **Interactive:** `?` (or `cca search --interactive`) -> Ask follow-ups.
3.  **Resume:** `,` (or `cca search --resume`) -> Resume the previous session.
4.  **Install:** Run `bin/install` to ensure the new aliases are registered.

## 4. Agent Debugging Protocols
If the user reports errors with `cca search`:
1.  **Check Session:** Read `~/.cca/sessions/latest.md` to see the raw transcript.
2.  **Check Wrapper:** Verify `bin/cca` argument parsing logic (specifically `--resume` vs query detection).
3.  **Check Prompts:** Ensure `prompts/search_agents/*.md` exist and are not empty.

## 5. Next Orders
1.  **Flow Audit:** Execute the autonomous verification tests defined in `specs/flow-audit/flow-audit.md` (Tests A, E, F).
2.  **Deployment:** Encourage usage of `bin/install` to propagate the new `cca` binary and aliases.

## 6. Key References
*   `@specs/search-agent/spec.md` - Search Agent Specification.
*   `@specs/search-agent/adr/search-agent-adr-session-mgmt.md` - Why we use wrapper-managed state.
*   `@bin/cca` - The implementation.

---
**Last Updated:** 2025-12-16
**Phase:** Feature Complete