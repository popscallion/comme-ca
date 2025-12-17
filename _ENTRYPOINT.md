# ENTRYPOINT (HANDOFF)

> **READ FIRST:** This file contains the critical context, recent changes, and immediate directives for the next agent or developer working on this repository.

## 1. The Situation
We are in the **Meta-Refinement** phase.
**New Strategic Context:** This repository (`comme-ca`) is now formally defined as the **"Distro"** (Public Tooling) in a larger ecosystem involving `comment-dit-on` (Lab), `comme-ci` (Config), and `larval-incubator` (Consumer).

## 2. Recent Actions
*   **Strategy:** Created `docs/SYNC_STRATEGY.md` defining the "Lab -> Distro -> Consumer" flow.
*   **Fix:** Updated `prompts/roles/pass.md` to enforce file write/commit before handoff generation.
*   **Spec:** Defined `specs/flow-audit/flow-audit.md` for lifecycle verification.
*   **Bootstrapping:** Created `bin/install` for easy onramp.
*   **Protocol:** Added "Shell Portability" and "Auto-Wrap" directives to `AGENTS.md` (and scaffolds).

## 3. Next Orders
*   **Flow Audit:** Execute the autonomous verification tests defined in `specs/flow-audit/flow-audit.md` (Tests A, E, F).
*   **Search Agent:** Review `specs/search-agent-recommendation.md` (pending creation) to decide on standalone vs. integrated approach.
*   **Resume:** Proceed with `clarify` -> `atomic-prompt-templates.md`.

## 4. Key References
*   `@docs/SYNC_STRATEGY.md` - The Ecosystem Architecture.
*   `@specs/active/context/bug-wrap-recursion-fail.md` - The forensic evidence of the bug.
*   `@prompts/roles/pass.md` - The suspected faulty prompt.

---
**Last Updated:** 2025-12-15
**Previous:** Ecosystem Definition & Meta-Refinement