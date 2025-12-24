<!--
@id: feature-openai-codex-requirements
@version: 1.0.0
@model: gemini-2.0-flash
-->

# REQUIREMENTS: OpenAI Codex Support

## 1. Goal
Extend `comme-ca` to support the official `@openai/codex` CLI tool as a first-class citizen, alongside Claude Code and Gemini CLI.

## 2. User Stories
*   **Setup:** As a user, I want to run `cca setup:codex` to verify installation and configure the environment for the Codex CLI.
*   **Pipe:** As a user, I want to run `cca git "..."` or `cca shell "..."` and have it executed by the Codex engine (`COMME_CA_ENGINE=codex`).
*   **Context:** As a user, I want the Codex CLI to respect the project's `AGENTS.md` context.

## 3. Technical Requirements
*   **Engine Key:** `codex`
*   **CLI Tool:** `@openai/codex` (npm package), binary `codex`.
*   **Execution Mode:** `codex exec` (Non-interactive/Scripted).
*   **Context File:** `CODEX.md` (Project root) pointing to `AGENTS.md`.

## 4. Constraints
*   Must not break existing Claude/Gemini support.
*   Must follow the "Pipe" wrapper pattern in `bin/cca`.
