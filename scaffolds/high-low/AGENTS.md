<!-- @protocol: comme-ca @version: 1.1.0 -->
# Agent Orchestration
**Powered by comme-ca Intelligence System**

This document defines how autonomous agents (Claude Code, Goose, or other AI assistants) should operate within this repository.

## Standard Roles

| Role | Alias | Command | When to Use |
|:-----|:------|:--------|:------------|
| **Mise (prep)** | `prep` | `goose run --instructions ~/dev/comme-ca/prompts/roles/mise.md` | Bootstrapping, environment setup, dependency checks |
| **Menu (plan)** | `plan` | `goose run --instructions ~/dev/comme-ca/prompts/roles/menu.md` | Requirements gathering, architecture planning, spec writing |
| **Taste (audit)** | `audit` | `goose run --instructions ~/dev/comme-ca/prompts/roles/taste.md` | Code review, drift detection, documentation sync |
| **Pipe (cc)** | `cc` | `cc git "instruction"` | Quick CLI translations (low-latency, single commands) |

## Context Detection

Standard roles automatically detect and adapt to project documentation:

- `@design.md` - Technical architecture, workflows, dependencies
- `@requirements.md` - Constraints, validation rules, quality gates
- `@tasks.md` - Current work items and priorities
- `@specs/` - Feature specifications

**Create these files to define project-specific behavior.** The roles will execute validation rules from requirements.md, follow workflows from design.md, and track progress in tasks.md.

## Setting Up Aliases

Add to your shell config (`~/.config/fish/config.fish` or `~/.zshrc`):

```bash
# High-Lift Agents
alias prep="goose run --instructions ~/dev/comme-ca/prompts/roles/mise.md"
alias plan="goose run --instructions ~/dev/comme-ca/prompts/roles/menu.md"
alias audit="goose run --instructions ~/dev/comme-ca/prompts/roles/taste.md"

# Low-Lift CLI Tool
export PATH="$HOME/dev/comme-ca/bin:$PATH"
```

## Usage

```bash
prep    # Bootstrap environment, install dependencies
plan    # Create specifications, gather requirements
audit   # Check for drift, validate compliance
cc git "command"  # Quick CLI translations
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

**"cc command not found"**
- Add `~/dev/comme-ca/bin` to PATH
- Verify executable: `chmod +x ~/dev/comme-ca/bin/cc`

**"Roles not finding project context"**
- Create `design.md` for architecture documentation
- Create `requirements.md` for validation rules
- Roles automatically detect and use these files

**"Need to update from comme-ca"**
- Run `cc update` to pull latest and diff AGENTS.md

## Integration with comme-ca

- **Repository:** `~/dev/comme-ca`
- **Prompts:** `~/dev/comme-ca/prompts/roles/`
- **CLI Wrapper:** `~/dev/comme-ca/bin/cc`

For full documentation: `~/dev/comme-ca/README.md`

---

**Version:** 1.1.0
**Source:** comme-ca Intelligence System
**Last Updated:** 2025-11-21
