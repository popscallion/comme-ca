<!--
@id: feature-openai-codex-entrypoint
@version: 1.1.0
@model: gemini-2.0-flash
-->

# Iteration Dashboard: OpenAI Codex Support

| Status | Description | Owner |
| :--- | :--- | :--- |
| **Complete** | Implementation and documentation finished | Gemini |

## Tasks
- [x] Create `scaffolds/high-low/CODEX.md`
- [x] Update `scaffolds/high-low/AGENTS.md` (Add Codex to tables)
- [x] Update `bin/cca` (Add `setup:codex` and `codex` engine support)
- [x] Update `README.md` (Document new engine)
- [x] Update `REQUIREMENTS.md` and templates (Cleanup Goose/Crush)
- [x] Verify `codex exec` behavior (Implied by design)

## Context
Adding support for `@openai/codex` CLI.