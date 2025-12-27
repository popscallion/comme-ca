# ENTRYPOINT

> **READ FIRST:** This file is the dynamic dashboard for this project.

## 1. The Situation

[Brief 1-2 sentence context]

## Inbox Rule (Non‑Negotiable)
If `_INBOX/` has contents, pause all work and triage interactively:
- Create or select a spec in `SPECS/`.
- Append raw text to `SPECS/<spec>/_RAW/RAW.md` (date heading if possible).
- Move non‑text artifacts to `SPECS/<spec>/_RAW/assets/` and reference them in `RAW.md`.

## Completion Rule (Spec Cleanup)
If a spec is marked completed (root `_ENTRYPOINT.md` or spec `_ENTRYPOINT.md`) but still exists in `SPECS/`:
- Synthesize outcomes into `DOCS/` or root docs (single source of truth).
- Archive chat to `SPECS/_ARCHIVE/chat-<spec-slug>.md`.
- Remove the spec directory from `SPECS/` (including `_RAW/assets/`).
- Missing date stamps in `RAW.md` must not block completion.

## 2. Iteration Dashboard

| Spec | Status | Focus | Next Action |
|:-----|:-------|:------|:------------|
| `[name]` | 🟡 Active | [Feature/Bug] | [Specific next step] |

## 3. Key Files

- `DESIGN.md`: Architecture and decisions.
- `REQUIREMENTS.md`: Product rules and logic.
- `README.md`: Documentation and workflows.
- `DOCS/`: Durable documentation and domain-specific guidance.

## 4. Quick Links

- **Specs:** `SPECS/`
- **Inbox:** `_INBOX/`
- **Docs:** `DOCS/`
