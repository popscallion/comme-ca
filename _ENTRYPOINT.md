# ENTRYPOINT (HANDOFF)

> **READ FIRST:** This file contains the critical context, recent changes, and immediate directives for the next agent or developer working on this repository.

## 1. The Situation
We have hardened the `comme-ca` ecosystem with "Universal Standards" and "Intelligent Triage". The system now enforces metadata headers, strict context preservation, and domain-specific knowledge gathering across all projects.

## 2. Recent Actions
*   **Universal Metadata:** Enforced `@id/@version/@model` headers in `AGENTS.md` and all scaffolds (`README`, `requirements`, etc.).
*   **Intelligent Triage:** Updated `plan` (Menu) to auto-detect loose artifacts, create `specs/[slug]/context/`, and ingest raw files forensically.
*   **Wrap Enforcement:** Created `commit-msg` hook scaffold to block commits missing `_ENTRYPOINT.md` updates.
*   **Domain Standards:** Updated `mise`, `plan`, `audit` prompts to strictly scan `docs/` for project-specific rules.
*   **Global Directives:** Added "No Emojis / Neutral Tone" constraints to `AGENTS.md`.

## 3. Next Orders (Verification)
**In `comme-ca` (This Repo):**
1.  **Test Triage:** Drop a loose file (e.g., `test-log.txt`) in root and run `plan` to verify it moves to `specs/feat-*/context/`.
2.  **Test Hook:** Try to commit a change without `_ENTRYPOINT.md`. Confirm it fails.

**In Target Projects (e.g., `comment-dit-on`):**
1.  **Sync:** Run `cca update` and `cca setup:all` to pull new prompts.
2.  **Verify Docs Scan:** Run `plan` and verify it explicitly mentions reading `docs/safe-prompting-principles.md`.
3.  **Verify Metadata:** Generate a new spec and check for the `@id` header.

## 4. Upcoming Sprint
*   **Reliable Testing Setup:** Automate the verification of these flows (scaffolding, hooking, tripping) to prevent regression.

## 5. Key References
*   `@AGENTS.md` - Now contains Universal Directives and Metadata Standards.
*   `@specs/active/intelligent-triage.md` - The spec defining the new ingestion logic.

---
**Last Updated:** 2025-12-12 12:55
**Previous:** Universal Metadata & Triage