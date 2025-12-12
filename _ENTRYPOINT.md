# ENTRYPOINT (HANDOFF)

> **READ FIRST:** This file contains the critical context, recent changes, and immediate directives for the next agent or developer working on this repository.

## 1. The Situation
We have completed the migration to a "Claude Code & Gemini CLI only" ecosystem. We removed all documentation and installer references to the deprecated tools (Goose, Crush) to align with the codebase state.

## 2. Recent Actions
*   **Docs Cleanup:** Updated `AGENTS.md` (root & scaffold), `README.md`, and `requirements.md` to remove Goose/Crush and feature Gemini/Claude.
*   **Installer Fix:** Updated `bin/install`:
    *   Removed broken terminal aliases (`prep`, `plan`, `audit`, `wrap`).
    *   Added `cca setup:gemini` to the install flow.
    *   Updated post-install instructions.
*   **Scaffold Sync:** Updated `scaffolds/high-low/AGENTS.md` to match the root version.

## 3. Next Orders
*   **Verify Install:** Run `./bin/install` locally to verify the new flow works.
*   **Drift Check:** Run `cca drift` to ensure your local config matches the new prompts/setup.

## 4. Key References
*   `@AGENTS.md` - Now the single source of truth for Claude/Gemini usage.
*   `@bin/install` - The updated bootstrap script.

---
**Last Updated:** 2025-12-12
**Phase:** Cleanup & Consolidation