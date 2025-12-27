# comme-ca

RepRap inspired, recursive repository for behavioral holons: AI agent prompts, CLI tools, and orchestration workflows.

## Rationale

Lean, single source of truth for agent intelligence. Decouples intelligence (prompts/roles) from infrastructure (dotfiles).

---

## Installation

### 1. One-Line Installer (Recommended)
```bash
./bin/install
```

### Dependencies
- **Claude Code**: `npm i -g @anthropic-ai/claude-code`
- **OpenCode**: (Supported engine) - TUI-native agentic IDE
- **OpenAI Codex**: `npm i -g @openai/codex` (First-class engine support)
- **Gemini CLI**: (Optional, for interactive agent sessions)

## Usage

### CLI (Pipe)
```bash
cca <tool> "<instruction>"
cca setup:sync  # Sync local protocol registry and tools
```

### Engines
Configure via `COMME_CA_ENGINE`:
- `claude` (Default)
- `opencode` (Uses `--agent flash` or `pro` via `COMME_CA_PROFILE`)
- `codex`

... [rest of content]
