# Agent Abstraction Research: Sources

## Source URLs
1. **Anthropic Skills Repository**
   - URL: https://github.com/anthropics/skills
   - Key File: `SKILL.md` format with YAML frontmatter
   - Pattern: Dynamic skill loading for specialized tasks

2. **Gemini CLI Multi-Agent Blog**
   - URL: https://aipositive.substack.com/p/how-i-turned-gemini-cli-into-a-multi
   - Author: Paul Datta
   - Key Pattern: File-system-as-state for task orchestration
   - Implementation: Custom commands in `.gemini/commands/`

## Key Quotes

### Anthropic Skills
> "Skills are folders of instructions, scripts, and resources that Claude loads dynamically to improve performance on specialized tasks."

> "Each skill is self-contained in its own folder with a SKILL.md file containing the instructions and metadata."

### Gemini CLI Agents
> "The entire state of the system—its task queue, plans, and logs—would live in a structured directory."

> "The 'agents' themselves are just standard Gemini CLI extensions, but the magic is in how they are invoked."

> "The child gemini process, despite being launched with the coder-agent extension, didn't know it was supposed to be the coder-agent."

> "The fix was to give the agent a direct, first-person command that established its identity for that specific run."

## Parallel Pattern Detection
| comme-ca | Anthropic Skills | Gemini CLI Agents |
|:---------|:-----------------|:------------------|
| `prompts/roles/*.md` | `skills/*/SKILL.md` | `.gemini/agents/*.md` |
| `_ENTRYPOINT.md` | N/A | `/agents/tasks/*.json` |
| `goose run --instructions` | Claude loads skill | `gemini -e agent-name -p` |
| Role personas (Mise, Menu) | Skill personas | Agent extensions |
