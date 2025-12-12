# ENTRYPOINT (HANDOFF)

> **READ FIRST:** This file contains the critical context, recent changes, and immediate directives for the next agent or developer working on this repository.

## 1. The Situation
We are in the **Meta-Refinement** phase, but currently troubleshooting a **Critical Tool Failure** in the `wrap` (Pass) agent. The agent is generating handoff text but failing to commit it to disk, causing state drift.

## 2. Recent Actions
*   **Bug Reporting:** Created `specs/active/context/bug-wrap-recursion-fail.md` detailing the silent failure of the wrap workflow.
*   **Documentation:** Created specs for `Atomic Prompt-Templates` and `Lab-Distro Sync` (pending implementation).

## 3. Next Orders
*   **CRITICAL FIX:** Investigate and fix the `prompts/roles/pass.md` logic to ensure it writes files and commits BEFORE outputting the handoff text.
*   **Resume:** Once fixed, proceed with `clarify` -> `atomic-prompt-templates.md`.

## 4. Key References
*   `@specs/active/context/bug-wrap-recursion-fail.md` - The forensic evidence of the bug.
*   `@prompts/roles/pass.md` - The suspected faulty prompt.

---
**Last Updated:** 2025-12-12 18:35
**Previous:** Meta-Refinement Sprint