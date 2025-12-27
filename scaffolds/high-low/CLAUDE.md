<!--
@id: claude-context
@version: 1.0.0
@model: claude-3-5-sonnet-20241022
-->
# Claude Context

Read `AGENTS.md` for all project context, architectural guidelines, and agent orchestration rules.

## Provider-Specific Mappings

- **Agents:** Map to Claude Code sessions.
- **Subagents:** Use Claude's native `Subagent` feature where available.
- **Skills:** Register `prompts/skills/*.md` (especially `serena.md`) as native Skills.
