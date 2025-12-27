<!--
@id: spec-completion-checklist
@version: 1.0.0
@model: codex
-->
# Spec Completion Checklist

Use this when a spec is marked **Completed** and still exists under `SPECS/`.

## Preconditions
- `_INBOX/` is empty (or triaged into `SPECS/<spec>/_RAW/RAW.md`).
- `SPECS/<spec>/_RAW/RAW.md` exists (append‑only).

## Steps
1. **Synthesize:** Update `DOCS/` or root docs so the outcome is a single source of truth.
2. **Archive Chat:** Concatenate `SPECS/<spec>/_RAW/RAW.md` into `SPECS/_ARCHIVE/chat-<spec-slug>.md`.
3. **Prune:** Remove `SPECS/<spec>/` (including `_RAW/assets/`).
4. **Verify:** Confirm `SPECS/<spec>/` no longer exists and the archive chat file does.

## Notes
- Missing date stamps in `RAW.md` should not block completion.
- Non‑text assets can be deleted after completion (git history is the fallback).
