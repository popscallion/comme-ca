# ENTRYPOINT (HANDOFF)

*   **Ecosystem Governance:** The `ecosystem/` directory signals that `comme-ci` manages `lab` and `distro`. `Taste` (Audit) now includes an "Ecosystem Audit Mode" to validate cross-repo sync.
*   **System Hardening:** `Tune` (Reflection) role added for process optimization. All roles now follow "Discovery First" and "Deep Verification" protocols.

> **READ FIRST:** This file contains the critical context, recent changes, and immediate directives for the next agent or developer working on this repository.

## 1. The Situation
**System Hardening Complete.**
We have successfully reorganized the `specs/` directory (flattened + `_ARCHIVE`) and implemented strict "Discovery First" and "Deep Verification" protocols across all roles (`Mise`, `Menu`, `Taste`). A new `Tune` role has been added for process reflection. The system is now robust against loose file assumptions and accidental data loss.

## 2. Recent Actions
*   **Spec Reorg:** Removed `specs/backlog`, flattened contents to `specs/`, renamed `specs/archived` to `specs/_ARCHIVE`.
*   **Role Updates:** Updated `Taste`, `Menu`, `Mise` with "Epistemic Rigor" blocks. Created `prompts/roles/tune.md`.
*   **Documentation:** Updated `README.md` and `AGENTS.md` (root & scaffold) to reflect new structure and logic.
*   **CLI:** Updated `bin/cca` to support `tune` command and setup.

## 3. Immediate Directives (Mission)
1.  **Maintain Hygiene:** Keep `specs/active` clean. Only active WIP specs should reside there.
2.  **Backlog Management:** Review `specs/backlog` when planning next iterations.

## 4. Key Files

- `AGENTS.md`: **[UPDATED]** Now includes "Non-Interactive Contract".
- `specs/backlog/`: **[NEW]** Holding area for unimplemented ideas.
- `specs/archived/`: Repository of completed work.

---
*   **Previous:** Spec Hygiene & Reflection Sprint.
*   **Last Updated:** 2025-12-21 16:30
**Previous:** Spec Audit & Cleanup
