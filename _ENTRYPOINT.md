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

## 3. Immediate Priorities (Next Agent)
**Target:** Ecosystem alignment.

1.  **Backport Shell Portability:** The Ecosystem Audit identified that "Shell Portability" directives are present in Distro (`comme-ca`) but missing from Lab (`comment-dit-on`). This needs to be backported to maintain the "Lab -> Distro" flow.
2.  **Lab Cleanup:** Verify if Lab (`comment-dit-on`) has renamed `AGENTS.md` to `SEARCH_AGENT_GUIDE.md` to resolve the semantic collision.
3.  **Search Agent Polish:** Monitor usage of `cca search` for any edge cases in the interactive mode.

## 4. Key References
*   `@specs/search-agent/spec.md` - Search Agent Specification.
*   `@bin/cca` - The implementation.
*   `@prompts/search_agents/` - Search prompt definitions.

---
**Last Updated:** 2025-12-17
**Phase:** Feature Complete / Operational