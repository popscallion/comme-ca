<!--
@id: feature-highpriority-precommit-guardrails-requirements
@version: 1.0.0
@model: gpt-5
-->
# Requirements: Pre-commit QA Guardrails

## Core Requirements
1. Scaffolded projects must include a `.pre-commit-config.yaml` with:
   - Ruff hooks (`ruff-check`, `ruff-format`).
   - Prettier hook (mirrors-prettier).
   - Local AI sentinel hook (`ai-qa-sentinel`) that runs on every commit.

2. Scaffolded projects must include `scripts/qa-sentinel.py` implementing:
   - Source of truth: `docs/TESTING-GUARDRAILS.md`.
   - Supplemental patterns: `docs/library-patterns.md` (if present).
   - Input: staged diff via `git diff --staged` (stdin allowed).
   - LLM providers: Anthropic/OpenAI (via `anthropic`/`openai` libs).
   - Soft-fail: if no API key, warn and exit 0.
   - Fail: if issues found, print "❌ QA Check Failed" and exit 1.
   - Pass: if clean, print "✅ QA Check Passed" and exit 0.

3. Documentation updates for generated projects:
   - `AGENTS.md`: Guardrails section stating `pre-commit run` is mandatory.
   - `README.md`: note recommending `uv`/`uvx` install and usage.

4. Portability: no tooling assumptions beyond Git + Python + uv/uvx. Must work with Codex/Claude/Gemini/OpenCode.

## Constraints
- Do not edit devcontainer scaffolds in this spec.
- Keep sentinel script self-contained and repo-relative.

## Reference
- Use `fahn-lai-bun` commit `ba0be88` as the template baseline for config and script behavior.
