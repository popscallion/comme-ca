# Handoff: comme-ca Audit & Consolidation

## 1. Context (The "Why")
We have just synchronized `comme-ca` with the **Larval Incubator** structural patterns (seen in `fahn-lai-bun`). This involved creating `_ENTRYPOINT.md` (dashboard), `inbox/`, `sources/raw-chats/`, and updating `scaffolds/` and `prompts/`.

**However**, the root-level documentation (`README.md`, `AGENTS.md`) is now STALE and drift exists between the root, the scaffolds, and the prompts. The user specifically requested CONSOLIDATION (e.g., merging `GUIDE.md` into `README.md`) to minimize document sprawl.

## 2. Your Mission (The "What")
Perform a comprehensive audit and consolidation of the `comme-ca` repository to ensure a **Single Source of Truth** and perfect alignment with the new Larval patterns.

## 3. Directives & Tasks

### A. Consolidation (Merge & Reduce)
1.  **Merge `GUIDE.md` into `README.md`:** The user stated `GUIDE.md` is user-facing and should be part of `README.md`.
    - *Action:* Move content from `GUIDE.md` to a "Workflows" section in `README.md`.
    - *Action:* Delete `GUIDE.md`.
    - *Action:* Update ALL references (in `prompts/`, `AGENTS.md`, `scaffolds/`) that pointed to `GUIDE.md` to point to `README.md#workflows`.

### B. Root Documentation Audit (Drift Detection)
1.  **`AGENTS.md` (Root) vs `scaffolds/high-low/AGENTS.md`:**
    - The scaffold was updated to include `_ENTRYPOINT.md` detection. The root file is likely stale.
    - *Action:* Make `scaffolds/high-low/AGENTS.md` the canonical source and COPY it to the root (or symlink if appropriate, but copy is safer for distributable). Ensure they are identical.
2.  **`README.md` Accuracy:**
    - Update "Architecture > Directory Structure" to include new folders (`inbox/`, `sources/raw-chats/`, `specs/<name>/`).
    - ensure "Usage" reflects the new "Dashboard" pattern in `_ENTRYPOINT.md`.

### C. Scaffold Parity (The "Template" Check)
1.  **Verify Scaffolds:** Ensure `scaffolds/high-low/` contains the *exact* best-practice versions of files intended for distribution (`_ENTRYPOINT.md`, `design.md`, `AGENTS.md`).
2.  **Drift Check:** `diff scaffolds/high-low/AGENTS.md AGENTS.md`.

### D. Spec Migration (Deferred Items)
1.  **Check Status:** `specs/headless-claude` and `specs/serena-mcp` were deferred.
2.  **Action:** If you are capable, complete the migration of these legacy specs to the `specs/<name>/_ENTRYPOINT.md` structure. If not, explicitly log them as "Debt" in the `requirements.md`.

## 4. Guardrails (How to act)
- **Delete Ruthlessly:** If a doc is redundant (like `GUIDE.md` vs `README.md`), merge and delete.
- **Single Source of Truth:** Do not allow two files to define the same rule.
- **Orthogonality:** `requirements.md` = Rules/Logic. `design.md` = Structure/Architecture. `README.md` = User Manual. Separation of concerns must be strict.
- **Verification:** After changes, run a `grep` for "GUIDE.md" to ensure no broken links remain.

## 5. Artifacts
- **Output:** A `walkthrough.md` summarizing the consolidation and drift fixes.
