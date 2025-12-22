<!--
@id: research-openai-codex
@version: 1.0.0
@model: gemini-2.0-flash
-->

# Research: OpenAI Codex Support

**Goal:** Extend `comme-ca` to support "OpenAI Codex" as a core tool alongside Claude Code and Gemini CLI.

## 1. Tool Identification
The most likely candidate is the open-source **Codex CLI** (`@openai/codex`), available via npm.
*   **Binary:** `codex`
*   **Capabilities:** Interactive coding agent, file system access, approvals workflow (Suggest/Auto/Full).
*   **Configuration:** `~/.codex/config.toml`
*   **Context:** Likely relies on prompt/stdin or specific context file conventions (to be defined by us).

## 2. Configuration Comparison

| Feature | Claude Code | Gemini CLI | Codex CLI (Proposed) |
| :--- | :--- | :--- | :--- |
| **Global Config** | `~/.claude/settings.json` | `~/.gemini/settings.json` | `~/.codex/config.toml` |
| **Project Context** | `CLAUDE.md` | `GEMINI.md` | `CODEX.md` (New Standard) |
| **Custom Commands** | `~/.claude/commands/*.md` | `~/.gemini/commands/*.toml` | `~/.codex/prompts/` (Hypothetical/TBD) |
| **Pipe Interface** | `echo "prompt" | claude -p` | Direct support | `codex exec "prompt"` |

## 3. Integration Plan

### A. Scaffolding
*   Create `scaffolds/high-low/CODEX.md`.
    *   Content: A pointer to `AGENTS.md` (similar to `CLAUDE.md` and `GEMINI.md`).
*   Update `scaffolds/high-low/AGENTS.md`.
    *   Add `CODEX.md` to the "Context Detection" list.

### B. CLI Wrapper (`bin/cca`)
*   **New Setup Command:** `setup:codex`
    *   Check if `codex` is installed (`npm list -g @openai/codex`).
    *   Configure `~/.codex/config.toml` if necessary.
*   **Pipe Support:**
    *   Map `ENGINE=codex` to `codex exec "{prompt}"`.

### C. Documentation
*   Update `README.md` to list Codex as a supported engine.
*   Update `AGENTS.md` to include Codex in the tool support tables.

## 4. Open Questions
*   Does `@openai/codex` support a "system prompt" file natively? (We might need to inject `AGENTS.md` content into every request if it doesn't auto-read a context file).
*   Does it have a specific directory for reusable prompts (roles)? If not, `cca` might need to manually inject role content when running `cca plan` via Codex.

## 5. Recommendation
Proceed with adding `CODEX.md` as the standard context anchor and use `codex exec` for the pipe interface.
