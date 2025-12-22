<!--
@id: search-agent
@version: 1.0.0
@model: gemini-2.0-flash
-->

# Search Agent Specification

## Overview
A unified search capability served via the `cca` CLI, acting as an abstraction layer for both human users (interactive REPL) and autonomous agents (tool invocation). It bridges the gap between the Lab's sophisticated prompt engineering (`comment-dit-on`) and the Distro's utilitarian access (`comme-ca`).

## User Experience (UX)

### 1. Human Interface (CLI)
Users interact via `cca search` or shell abbreviations.

**Invocation Patterns:**
- **Single Shot:** `cca search "What is the latest context7 version?"`
  - Output: Streamed answer to stdout. Exit.
- **Interactive REPL:** `cca search --interactive` (or `?`)
  - Output: Opens a session where user can ask follow-ups.
- **Resume Session:** `cca search --resume` (or `,`)
  - Behavior: Reconnects to the last session (or specified ID).

**Shell Integration (Fish):**
```fish
abbr -a ? 'cca search --interactive'
abbr -a , 'cca search --resume'
```

### 2. Agent Interface (Tool)
Agents (e.g., `clarify`) invoke `cca search` as a tool.

**Invocation:**
`cca search --json "query"`

**Output:**
```json
{
  "answer": "Context7 v1.2.0 released on...",
  "sources": [
    {"url": "...", "title": "..."}
  ],
  "confidence": "high"
}
```

## Architecture

### The Wrapper (`bin/cca`)
The `cca` script handles:
1.  **Flag Parsing:** `--interactive`, `--session-id`, `--resume`, `--json`.
2.  **Prompt Selection:**
    - `fast` (GPT-OSS-120b)
    - `smart` (Haiku 4.5 / Sonnet)
3.  **Engine Dispatch:** Calls `claude` or `gemini` with the constructed system prompt and user query.

### The Brain (Prompts)
Located in `prompts/search_agents/`.
- **Primary:** `haiku45.md` (Principle-Heavy, Semantic Routing).
- **Secondary:** `gpt-oss-120b.md` (Rule-Heavy, Fast).

### Context Awareness
- **User Mode:** Context-Unaware (default). Prevents pollution.
- **Agent Mode:** Context-Aware. Agents pass relevant context snippets if needed, or rely on the `search` tool to be purely external validation.

## Implementation Roadmap

1.  **Port Prompts:** Copy `prompts/search_agents/` from `comment-dit-on` (Lab) to `comme-ca` (Distro).
2.  **Update `bin/cca`:** Add `search` command and flag parsing logic.
3.  **Shell Config:** Add abbreviations to `AGENTS.md` setup instructions.

## Open Questions
1.  **Engine Flags:** Exact syntax for `claude` / `gemini` session persistence?
2.  **JSON Mode:** Does the underlying engine support structured output enforcement, or do we rely on prompt engineering ("Output JSON only")?
