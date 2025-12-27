<!--
@id: entrypoint
@version: 1.0.0
@model: claude-3-5-sonnet-20241022
-->
# ENTRYPOINT (Handoff)

> **READ FIRST:** This file contains the critical context, recent changes, and immediate directives for the next agent or developer working on this repository.

## 1. The Situation
[High-level summary of the project state. What are we building? What is the current phase?]

## 2. Inbox Rule (Non‑Negotiable)
If `_INBOX/` has contents, pause all work and triage interactively:
- Create or select a spec in `SPECS/`.
- Append raw text to `SPECS/<spec>/_RAW/RAW.md` (date heading if possible).
- Move non‑text artifacts to `SPECS/<spec>/_RAW/assets/` and reference them in `RAW.md`.

## 3. Completion Rule (Spec Cleanup)
If a spec is marked completed (root `_ENTRYPOINT.md` or spec `_ENTRYPOINT.md`) but still exists in `SPECS/`:
- Synthesize outcomes into `DOCS/` or root docs (single source of truth).
- Archive chat to `SPECS/_ARCHIVE/chat-<spec-slug>.md`.
- Remove the spec directory from `SPECS/` (including `_RAW/assets/`).
- Missing date stamps in `RAW.md` must not block completion.

## 4. Recent Actions
*   [Action 1]
*   [Action 2]

## 5. Next Orders
*   [Immediate Next Step 1]
*   [Immediate Next Step 2]

## 6. Key References
*   `@_ENTRYPOINT.md` - Iteration Dashboard (Checklist).
*   `@DESIGN.md` - Architecture source of truth.
*   `@AGENTS.md` - Role definitions.
*   `@DOCS/` - Durable documentation and domain-specific guidance.
*   `@SPECS/` - Ephemeral specifications and active work.

---
**Last Updated:** {{DATE}} (YYYY-MM-DD HH:MM)
**Previous:** [Summary of session before this one]
