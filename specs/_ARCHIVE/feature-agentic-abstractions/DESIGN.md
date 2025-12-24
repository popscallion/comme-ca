<!--
@id: design-agentic-abstractions
@version: 1.0.0
@model: gemini-2.0-flash
-->
# DESIGN: Agentic Abstractions

## 1. Directory Structure Changes

```text
comme-ca/
├── prompts/
│   ├── roles/          # Agents (mise, menu, taste)
│   ├── skills/         # NEW: Skills (Reusable Procedures)
│   │   └── serena.md   # Moved/Refined from capabilities/
│   ├── subagents/      # NEW: Specialist Workers
│   │   └── code-reviewer.md
│   └── capabilities/   # DEPRECATED/MERGED into Skills or kept for raw tools?
│       └── serena.md   # -> moved to skills/
```

## 2. The Abstraction Layer (`AGENTS.md`)

We will add a "Agentic Architecture" section to `AGENTS.md` defining the 4 primitives.

## 3. Implementation Details

### A. Skills (Serena)
- **Concept:** A Markdown file containing *instructions* on how to use a *Tool*.
- **Implementation:**
  - `prompts/skills/serena.md`: "When you need to edit code, use `replace_symbol_body`..."
  - Agents load this file into their system prompt or context window.

### B. Subagents (`code-reviewer`)
- **Concept:** A distinct persona for a focused task.
- **Invocation:** `cca subagent:code-reviewer "Review src/main.rs"`
- **CLI Support:** Update `bin/cca` to recognize `subagent:` prefix and route to `prompts/subagents/`.

### C. Agents (Roles)
- **Mise/Menu/Taste:** Updated headers to explicitly state "You are an Agent... you use Skills... you delegate to Subagents."

## 4. Provider Mapping

| Concept | Claude Code | Gemini CLI | Codex |
| :--- | :--- | :--- | :--- |
| **Agent** | Session | CLI Loop | Assistant Thread |
| **Subagent** | Native `Subagent` | `gemini -c` (Recursive) | New Thread/Assistant |
| **Skill** | Native `Skill` | Prompt Context | Instruction Injection |
| **Tool** | MCP | MCP | Function Call |

## 5. Migration Strategy
1.  Move `serena.md` to `prompts/skills/`.
2.  Update `AGENTS.md` definitions.
3.  Update role prompts to point to new skill path.
4.  Create `prompts/subagents/` and example.
5.  Update `cca` binary logic (optional but good for DX).
