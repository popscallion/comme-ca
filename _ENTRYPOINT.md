# ENTRYPOINT (HANDOFF)

> **READ FIRST:** This file contains the critical context, recent changes, and immediate directives for the next agent or developer working on this repository.

## 1. The Situation
We are in the **Meta-Refinement** phase.
**New Strategic Context:** This repository (`comme-ca`) is now formally defined as the **"Distro"** (Public Tooling) in a larger ecosystem involving `comment-dit-on` (Lab), `comme-ci` (Config), and `larval-incubator` (Consumer).

## 2. Recent Actions
*   **Strategy:** Created `docs/SYNC_STRATEGY.md` defining the "Lab -> Distro -> Consumer" flow.
*   **Bug Reporting:** Created `specs/active/context/bug-wrap-recursion-fail.md` detailing the silent failure of the wrap workflow.
*   **Documentation:** Created specs for `Atomic Prompt-Templates` and `Lab-Distro Sync` (pending implementation).

## 3. Next Orders
*   **CRITICAL FIX:** Investigate and fix the `prompts/roles/pass.md` logic to ensure it writes files and commits BEFORE outputting the handoff text.
*   **Search Agent:** Implement `bin/search` (native search agent) as per the roadmap, so downstream consumers (`larval`) can inherit it.
*   **Resume:** Once fixed, proceed with `clarify` -> `atomic-prompt-templates.md`.

## 4. Key References
*   `@docs/SYNC_STRATEGY.md` - The Ecosystem Architecture.
*   `@specs/active/context/bug-wrap-recursion-fail.md` - The forensic evidence of the bug.
*   `@prompts/roles/pass.md` - The suspected faulty prompt.

---
**Last Updated:** 2025-12-15
**Previous:** Ecosystem Definition & Meta-Refinement