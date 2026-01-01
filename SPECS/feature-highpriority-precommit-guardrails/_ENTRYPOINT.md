<!--
@id: feature-highpriority-precommit-guardrails-entrypoint
@version: 1.0.0
@model: gpt-5
-->
# Spec Entrypoint: feature-highpriority-precommit-guardrails

## Summary
Add portable QA guardrails to the comme-ca scaffolding system via `pre-commit`, using an adversarial QA sentinel that evaluates staged diffs against `docs/TESTING-GUARDRAILS.md` and supplemental patterns.

## Reference Implementation
Use `fahn-lai-bun` at commit `ba0be88` as the reference for configuration and script structure.

## Goals
- Standardize `pre-commit` hooks across generated projects.
- Provide a QA guardrails hook driven by `docs/TESTING-GUARDRAILS.md`.

## Upstreaming Note (Bidirectional)
While active guardrail development is happening in `fahn-lai-bun`, changes should be upstreamed into comme-ca scaffolds. Once comme-ca becomes the active guardrail development site, downstream changes should be mirrored back into `fahn-lai-bun`.

## Sync Awareness
Before implementing any sync/check tooling, scan existing documentation and specs in comme-ca for planned synchronization mechanisms (e.g., `DOCS/SYNC_STRATEGY.md` and any related specs) to avoid duplicating or conflicting flows.
- Prefer `uv`/`uvx` for installation and usage.
- Ensure portability across Codex, Claude, Gemini, and OpenCode.

## Non-Goals
- No devcontainer changes in this spec.
- No CI integration in this spec (local hooks only).

## Status
Draft.

## Next Actions
- Read `requirements.md`, `design.md`, `tasks.md` in this spec.
