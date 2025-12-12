<!-- @protocol: comme-ca @version: 1.2.0 -->
# Agent Orchestration
**Powered by comme-ca Intelligence System**

This document defines how autonomous agents (Claude Code, Gemini CLI) should operate within this repository.

## Standard Roles

| Role | Alias | Command | When to Use |
|:-----|:------|:--------|:------------|
| **Mise (prep)** | `prep` | `/prep` (Claude/Gemini) | New project scaffolding, environment setup, dependency checks |
| **Menu (plan)** | `plan` | `/plan` (Claude/Gemini) | Requirements gathering, architecture planning, spec writing |
| **Taste (audit)** | `audit` | `/audit` (Claude/Gemini) | Code review, drift detection, documentation sync |
| **Pass (wrap)** | `wrap` | `/wrap` (Claude/Gemini) | Handoff, session closure, context consolidation |
| **Pipe (cca)** | `cca` | `cca git "instruction"` | Quick CLI translations (low-latency, single commands) |

## Context Utilities (Ad-Hoc)

| Tool | Alias | Command | When to Use |
|:-----|:------|:--------|:------------|
| **Clarify** | `clarify` | `cca clarify` | Pre-planning exploration & ambiguity resolution |
| **What** | `what` | `cca what` | Generate PRD/Research Synthesis from context |
| **Why** | `why` | `cca why` | Generate Decision Record/Commit Context |

## Context Detection

Standard roles automatically detect and adapt to project documentation:

- `@_ENTRYPOINT.md` - (Mandatory) The current project state and context handover
- `@design.md` - Technical architecture, workflows, dependencies
- `@requirements.md` - Constraints, validation rules, quality gates
- `@tasks.md` - Current work items and priorities
- `@specs/` - Feature specifications

**Create these files to define project-specific behavior.** The roles will execute validation rules from requirements.md, follow workflows from design.md, and track progress in tasks.md.

## Universal Standards (CRITICAL)

All generated markdown artifacts (Prompts, Specs, ADRs, PRDs) MUST begin with a standardized metadata block to ensure version control compatibility:

```markdown
<!--
@id: [kebab-case-unique-id]
@version: [semver]
@model: [model-id]
-->
```

- **@id:** Unique identifier for the artifact (file-system safe)
- **@version:** Semantic versioning (start at 1.0.0, increment on iterations)
- **@model:** The model used to generate the artifact

## Setting Up Aliases

Add to your shell config (`~/.config/fish/config.fish` or `~/.zshrc`):

```bash
# Low-Lift CLI Tool
export PATH="$HOME/dev/comme-ca/bin:$PATH"
```

Then configure your tools:
```bash
cca setup:all      # Configures both Claude Code and Gemini CLI
```

## Multi-Tool Integration

Comme-ca prompts work with multiple AI CLI tools.

| Tool | Setup Command | Config Location |
|:-----|:--------------|:----------------|
| **Claude Code** | `cca setup:claude` | `~/.claude/commands/` |
| **Gemini CLI** | `cca setup:gemini` | `~/.gemini/commands/` |

```bash
# Check tool status
cca setup:list

# Configure tools
cca setup:all        # All tools at once
cca setup:claude     # Individual tool
cca setup:gemini     # Individual tool

# Maintenance
cca drift            # Check for prompt updates
cca setup:sync       # Update drifted tools
```

## Usage

```bash
/prep   # Bootstrap environment, install dependencies
/plan   # Create specifications, gather requirements
/audit  # Check for drift, validate compliance
/wrap   # Consolidate docs, commit, and generate handoff
cca git "command"  # Quick CLI translations
```

## Project Extensions

Only create custom roles when standard roles genuinely cannot cover your use case:
- **Different permissions** (e.g., a Deployer that pushes to production)
- **Different output types** (e.g., a Trainer creating learning materials)
- **Different interaction patterns** (e.g., interactive debugging)

Most project-specific behavior should go in `requirements.md` (constraints/rules) or `design.md` (architecture/workflows), not custom roles.

### Example: Adding a Custom Role

```markdown
## Project-Specific Roles

### Deployer
**Responsibility:** Deploy to production environments
**Permissions:**
- ✅ Push to production
- ✅ Run deployment scripts
- ❌ Modify source code

**Workflow:**
1. Verify audit passes
2. Run deployment script
3. Verify deployment health
```

## Troubleshooting

**"cca command not found"**
- Add `~/dev/comme-ca/bin` to PATH
- Verify executable: `chmod +x ~/dev/comme-ca/bin/cca`

**"Roles not finding project context"**
- Create `design.md` for architecture documentation
- Create `requirements.md` for validation rules
- Roles automatically detect and use these files

**"Need to update from comme-ca"**
- Run `cca update` to pull latest and diff AGENTS.md

## Integration with comme-ca

- **Repository:** `~/dev/comme-ca`
- **Prompts:** `~/dev/comme-ca/prompts/roles/`
- **CLI Wrapper:** `~/dev/comme-ca/bin/cca`

For full documentation: `~/dev/comme-ca/README.md`

---

**Version:** 1.2.0
**Source:** comme-ca Intelligence System
**Last Updated:** 2025-11-23
