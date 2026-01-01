<!--
@id: feature-highpriority-precommit-guardrails-design
@version: 1.0.0
@model: gpt-5
-->
# Design: Pre-commit QA Guardrails

## Architecture

### Hook Layer
- Pre-commit configuration is added to scaffolds.
- Standard hooks: Ruff and Prettier.
- Local hook: `ai-qa-sentinel` uses a Python script in `scripts/`.

### Sentinel Script
- Read `docs/TESTING-GUARDRAILS.md` as the authoritative policy.
- Optionally include `docs/library-patterns.md` for runtime safety patterns.
- Inspect staged changes only (`git diff --staged`).
- Provider selection:
  - Prefer Anthropic when `ANTHROPIC_API_KEY` is set.
  - Fall back to OpenAI if only `OPENAI_API_KEY` is set.
  - Soft-fail (exit 0) if neither key is present.
- Output is strict JSON from the model; parse and enforce.

### Install/Run Guidance
- Use `uv` tooling for pre-commit installation and execution:
  - `uv tool install pre-commit`
  - `uv tool run pre-commit install`
  - `uv tool run pre-commit run`

## Scaffold Integration Points
- Add `.pre-commit-config.yaml` to scaffold templates.
- Add `scripts/qa-sentinel.py` to scaffold templates.
- Update `AGENTS.md` and `README.md` templates to mention guardrails + uv/uvx.

## Reference Implementation
Mirror the structure and behavior from `fahn-lai-bun` at commit `ba0be88`.
