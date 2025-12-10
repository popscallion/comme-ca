# ENTRYPOINT (SITREP)

> **READ FIRST:** This file contains the critical context, recent changes, and immediate directives for the next agent or developer working on this repository.

## 1. The Situation
We have just integrated the "Pass" (wrap) role into the `comme-ca` system. This role standardizes session handoffs and ensures documentation hygiene. `_ENTRYPOINT.md` (this file) is now a mandatory context file for all operations.

## 2. Recent Actions
*   **Role Installation:** Added `prompts/roles/pass.md`.
*   **Documentation Update:** Updated `AGENTS.md` and `scaffolds/high-low/AGENTS.md` with the new role.
*   **Tooling Update:**
    *   Updated `bin/cca` to generate `_ENTRYPOINT.md` during `init`.
    *   Updated `bin/install` to include the `wrap` alias.
*   **Protocol Update:** Updated `prompts/roles/mise.md` and `prompts/roles/taste.md` to enforce `_ENTRYPOINT.md` usage.
*   **Spec Migration:** Moved `pass/` implementation notes to `specs/pass/`.

## 3. Next Orders
*   **Adopt `wrap`:** Use the `wrap` command (or `goose run --instructions prompts/roles/pass.md`) to end sessions.
*   **Maintain Hygiene:** Ensure `_ENTRYPOINT.md` is updated before every commit (handled by `wrap`).

## 4. Key References
*   `@tasks.md` - Master checklist.
*   `@design.md` - Architecture source of truth.
*   `@AGENTS.md` - Role definitions.

---
**Last Updated:** 2025-12-10
**Phase:** Integration Complete