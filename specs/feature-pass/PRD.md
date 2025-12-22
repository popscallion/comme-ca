# Pass (wrap) Role: PRD & Specification

## 1. Overview
**Role Name:** Pass (Expediter)
**Command Alias:** `wrap`
**Metaphor:** The "Pass" in a kitchen—the final checkpoint where dishes are inspected, wiped down, and handed off to the next station.

## 2. Problem Statement
AI agents often leave repositories in a "messy" state at the end of a session:
- Documentation lags behind code changes.
- Commit messages are generic.
- The next agent (or human) lacks context on *what* was done and *why*.
- "Source of Truth" becomes fragmented across multiple files.

## 3. Goals
1.  **Enforce Hygiene:** Consolidate documentation before every commit.
2.  **Preserve Context:** Generate a structured handoff in `_ENTRYPOINT.md`.
3.  **Standardize Handoff:** Output a copy-pasteable prompt for the next agent.

## 4. Role Behavior (The Protocol)

### A. Documentation Hygiene (The "Wipe Down")
*   **Trigger:** Before any commit.
*   **Action:**
    *   Scan `git status` for modified files.
    *   Update `DESIGN.md` if architecture changed.
    *   Update `_ENTRYPOINT.md` if items were completed.
    *   **Prune:** Mark outdated info as legacy or archive it. Avoid "split brain" (conflicting info).

### B. The Handoff (`_ENTRYPOINT.md`)
*   **Mandatory File:** Every project MUST have an `_ENTRYPOINT.md`.
*   **Structure:**
    *   `1. The Situation:` High-level context.
    *   `2. Recent Actions:` Technical summary of the session.
    *   `3. Next Orders:` Immediate next steps for the incoming agent.

### C. The Commit
*   Stage all consolidated changes (`git add .`).
*   Write a semantic commit message.
*   Push to remote.

### D. The Handoff Output
*   **Final Artifact:** A code block containing the prompt for the next session.
*   **Format:** "You are picking up... Context: Read _ENTRYPOINT.md... Status: ... Mission: ..."

## 5. Integration
*   **File:** `prompts/roles/pass.md`
*   **CLI Alias:** `wrap` -> `goose run --instructions .../pass.md`
*   **Enforcement:**
    *   `mise.md` checks for `_ENTRYPOINT.md`.
    *   `taste.md` audits for stale `_ENTRYPOINT.md`.
