# Agent Abstraction Research

**Status:** 🟡 Active  
**Priority:** 2nd (After Process Hardening)

## The Situation
Research how Anthropic's Skills and Gemini CLI's multi-agent patterns could integrate with `comme-ca`. This is a discovery and clarification phase—no implementation yet.

## Iteration Dashboard
| Item | Status | Focus | Next Action |
|:-----|:-------|:------|:------------|
| Codebase Discovery | ⚪ Pending | comme-ca structure | Map existing patterns |
| Anthropic Skills | ⚪ Pending | Research | Analyze SKILL.md structure |
| Gemini CLI Agents | ⚪ Pending | Research | Analyze file-system-as-state |
| Clarification | ⚪ Pending | Integration | Propose mapping to roles |

## Key Concepts (From Research)

### Anthropic Skills
- **Definition:** Folders with `SKILL.md` files containing YAML frontmatter + instructions.
- **Pattern:** Dynamic loading of specialized task instructions.
- **Relevance:** Similar to `comme-ca/prompts/roles/` structure.

### Gemini CLI Multi-Agent
- **Pattern:** File-system-as-state (tasks, plans, logs in directory).
- **Sub-Agent Spawning:** CLI invokes new `gemini-cli` instance with specific extension.
- **Relevance:** Matches `comme-ca` "role" invocation via `goose run --instructions`.

## Key References
- `_RAW/sources.md` - Source URLs and notes.
- `REQUIREMENTS.md` - Research questions and success criteria.
- `DESIGN.md` - Proposed integration points.

---
**Last Updated:** 2025-12-22 14:39
