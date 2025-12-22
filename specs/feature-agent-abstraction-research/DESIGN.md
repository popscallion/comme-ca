# Agent Abstraction Research Design

## Current comme-ca Architecture

```
prompts/
├── roles/           # Persistent agent personas
│   ├── mise.md      # System bootstrapper
│   ├── menu.md      # Architect/planner
│   ├── taste.md     # QA/drift detector
│   ├── pass.md      # Handoff/session closure
│   └── tune.md      # Process reflector
├── pipe/            # Single-shot prompts
└── capabilities/    # Tool-specific instructions (Serena)
```

## External Patterns

### Anthropic Skills Structure
```
skills/
└── skill-name/
    ├── SKILL.md     # YAML frontmatter + instructions
    └── assets/      # Scripts, templates, resources
```

**SKILL.md Format:**
```yaml
---
name: my-skill-name
description: What this skill does and when to use it
---
# Instructions
[Markdown content...]
```

### Gemini CLI Multi-Agent Structure
```
.gemini/
├── commands/        # Custom commands (TOML files)
│   └── agents/
│       ├── run.toml
│       └── start.toml
├── agents/
│   ├── tasks/       # JSON task queue
│   ├── plans/       # Long-term context
│   ├── logs/        # Agent output
│   └── workspace/   # Scratchpad
└── extensions/      # Agent definitions
```

## Proposed Integration Points

### Option A: Adopt YAML Frontmatter
Add metadata to role prompts:
```yaml
---
name: taste
alias: audit
version: 1.1.0
triggers: ["audit", "drift", "check"]
---
# Taste (audit): QA & Drift Detector
...
```

**Pros:** Machine-readable metadata, version tracking.
**Cons:** Requires parser, adds complexity.

### Option B: File-System Task Queue
Add task state directory:
```
.comme-ca/
├── tasks/           # JSON task files
├── logs/            # Session logs
└── workspace/       # Scratchpad
```

**Pros:** Enables automation, parallel agents.
**Cons:** Requires tooling, diverges from human-readable ethos.

### Option C: Sub-Agent Invocation (Recipes)
Allow roles to invoke other roles:
```markdown
## Sub-Agent Directive
When a task requires specialized work:
1. Write task to `.comme-ca/tasks/`
2. Invoke: `goose run --instructions .../[role].md --context task.json`
```

**Pros:** Enables orchestration.
**Cons:** Complexity, debugging difficulty.

## Verification Plan

### Phase 1: Codebase Discovery
- [ ] Map current `prompts/roles/` structure.
- [ ] Identify existing patterns that match external systems.

### Phase 2: Clarification
- [ ] Present findings to user.
- [ ] Get direction on which patterns to adopt.

### Phase 3: Recommendations
- [ ] Draft ADR if adopting patterns.
- [ ] Update `DESIGN.md` with integration plan.
