<!--
@id: gemini-context
@version: 1.0.0
@model: gemini-2.0-flash
-->
# Gemini Context

@AGENTS.md

## Provider-Specific Mappings

- **Agents:** Map to Gemini CLI agent loops.
- **Subagents:** Implement as nested `gemini -c` calls or separate session contexts.
- **Skills:** Injected as prompt sections from `prompts/skills/*.md`.