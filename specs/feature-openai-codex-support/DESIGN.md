<!--
@id: feature-openai-codex-design
@version: 1.0.0
@model: gemini-2.0-flash
-->

# DESIGN: OpenAI Codex Support

## 1. Architecture

### A. The Wrapper (`bin/cca`)
*   **New Engine:** Add `codex` case to `execute_engine()`.
    *   Command: `codex exec "$prompt"`
    *   *Note:* Ensure `--non-interactive` or equivalent is implied by `exec`.
*   **New Setup:** Add `setup:codex()` function.
    *   Check for binary: `command -v codex`.
    *   Check package: `npm list -g @openai/codex` (optional verification).
    *   Config: Create `~/.codex/config.toml` if missing (minimal default).

### B. Scaffolding (`scaffolds/high-low/`)
*   **New Context:** `CODEX.md`
    *   Content:
        ```markdown
        # OpenAI Codex Context
        
        @AGENTS.md
        ```
*   **Update `AGENTS.md`:** Add Codex to the "Context Detection" and "Multi-Tool Integration" sections.

## 2. Integration Patterns

| Component | Pattern |
| :--- | :--- |
| **Context** | `CODEX.md` (Root) -> `AGENTS.md` |
| **Execution** | `codex exec` |
| **Config** | `~/.codex/config.toml` |

## 3. Workflows

### Setup
```bash
cca setup:codex
# -> Checks for codex binary
# -> Ensures ~/.codex exists
# -> Reports status
```

### Pipe
```bash
export COMME_CA_ENGINE=codex
cca git "list branches"
# -> codex exec "You are a strict command-line translator... list branches"
```
