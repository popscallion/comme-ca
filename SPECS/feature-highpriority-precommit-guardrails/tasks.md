<!--
@id: feature-highpriority-precommit-guardrails-tasks
@version: 1.0.0
@model: gpt-5
-->
# Tasks: Pre-commit QA Guardrails

1. Audit existing scaffold templates for current hook or QA patterns.
2. Add `.pre-commit-config.yaml` template with Ruff + Prettier + local sentinel hook.
3. Add `scripts/qa-sentinel.py` template (based on `fahn-lai-bun` commit `ba0be88`).
4. Update scaffolded `AGENTS.md` with a Guardrails section (pre-commit mandatory + uv/uvx usage).
5. Update scaffolded `README.md` with uv/uvx install/run guidance for pre-commit.
6. Validate a fresh scaffold output includes these files.
7. Document any deviations in `DOCS/` if needed.
