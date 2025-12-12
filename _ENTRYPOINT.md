# ENTRYPOINT (HANDOFF)

> **READ FIRST:** This file contains the critical context, recent changes, and immediate directives for the next agent or developer working on this repository.

## 1. The Situation
We are in the **Meta-Refinement** phase. Having hardened the core system with Universal Standards, we are now focusing on systemic resilience (preventing data loss between prompts and templates) and optimizing the contributor workflow (syncing between Lab and Distro).

## 2. Recent Actions
*   **Agent Refinement:** Updated `pass` (Wrap) agent to force a critical rewrite of "The Situation" during handoffs, preventing stale context.
*   **Spec Generation:** Created `specs/active/atomic-prompt-templates.md` to address prompt/template data loss.
*   **Spec Generation:** Created `specs/active/lab-distro-sync.md` to streamline the Lab-to-Distro release process.

## 3. Next Orders
*   **Design Phase:** Run `clarify` on `specs/active/atomic-prompt-templates.md` to explore implementation details for schema validation.
*   **Design Phase:** Run `clarify` on `specs/active/lab-distro-sync.md` to define the `cca publish` workflow.
*   **Implementation:** Once clarified, move to implementation of these system upgrades.

## 4. Key References
*   `@specs/active/` - New specs awaiting refinement.
*   `@prompts/roles/pass.md` - Updated handoff logic.

---
**Last Updated:** 2025-12-12 18:24
**Previous:** Universal Metadata & Triage