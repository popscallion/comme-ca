# Agent Abstraction Research Requirements

## Overview
Investigate how external agent abstraction patterns (Anthropic Skills, Gemini CLI multi-agent) could enhance or integrate with the `comme-ca` role system.

## Research Questions

### RQ-1: Skill/Role Equivalence
How do Anthropic's `SKILL.md` files compare to `comme-ca/prompts/roles/*.md`?
- Are they functionally equivalent?
- What metadata does Anthropic use that we lack?
- Should we adopt YAML frontmatter for roles?

### RQ-2: File-System-as-State
Should `comme-ca` adopt a task queue pattern similar to Gemini CLI's `.gemini/agents/tasks/`?
- Current: `_ENTRYPOINT.md` as manual dashboard.
- Alternative: JSON task files for machine-readable state.
- Trade-off: Human readability vs. automation potential.

### RQ-3: Sub-Agent Spawning
How can `comme-ca` enable one role to invoke another?
- Current: Manual invocation (`goose run --instructions ...`).
- Anthropic: Claude loads skills dynamically.
- Gemini: Shell command spawns new CLI instance with extension.

### RQ-4: Identity Crisis Prevention
The Gemini blog describes a bug where the sub-agent didn't know its role. How do we prevent this?
- Ensure role prompts establish identity explicitly.
- Pass context (task ID, parent role) to sub-agents.

## Success Criteria
- [ ] Clear mapping between comme-ca roles and external patterns.
- [ ] Recommendation: Adopt, adapt, or ignore each pattern.
- [ ] If adopting, draft implementation plan.

## Out of Scope
- Actual implementation (this is research only).
- Performance benchmarks.
- Cost analysis of multi-agent calls.
