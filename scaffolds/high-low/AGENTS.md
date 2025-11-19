# Agent Orchestration & Roles
**Powered by comme-ca Intelligence System**

This document defines how autonomous agents (Claude Code, Goose, or other AI assistants) should operate within this repository. All agents must read and follow these orchestration rules.

## Quick Reference

| Agent Role | Alias | Command | When to Use |
|:-----------|:------|:--------|:------------|
| **Mise (prep)** | `prep` | `goose run --instruction-file ~/dev/comme-ca/prompts/roles/mise.md` | Bootstrapping, environment setup, dependency checks |
| **Menu (plan)** | `plan` | `goose run --instruction-file ~/dev/comme-ca/prompts/roles/menu.md` | Requirements gathering, architecture planning, spec writing |
| **Taste (audit)** | `audit` | `goose run --instruction-file ~/dev/comme-ca/prompts/roles/taste.md` | Code review, drift detection, documentation sync |
| **Pipe (cc)** | `cc` | `cc git "instruction"` | Quick CLI translations (low-latency, single commands) |

## Core Principles

1. **Separation of Concerns:** Intelligence (prompts/agents) is managed in `~/dev/comme-ca`, while project-specific code lives here.
2. **Single Source of Truth:** Agent behavior is defined in `~/dev/comme-ca/prompts/roles/`, not duplicated per project.
3. **Explicit Invocation:** Agents are called by role, not by generic "AI help me."
4. **Context Awareness:** Before working, agents must understand project structure, existing documentation, and current tasks.

## When to Use Each Agent

### Mise (prep) - System Bootstrapper
**Use when:**
- Setting up this repository on a new machine
- Onboarding a new developer
- Verifying dependencies after a long break
- Troubleshooting "it works on my machine" issues

**What it does:**
- Checks for git initialization
- Validates `AGENTS.md` exists
- Ensures required tools are installed
- Verifies project structure
- Provides a "System Readiness Report"

**Output:** Pass/Warn/Fail checklist with actionable fixes

### Menu (plan) - Architect & Requirements Gatherer
**Use when:**
- Starting a new feature or project
- Clarifying vague requirements
- Designing system architecture
- Breaking down large work into tasks
- Documenting decisions before implementing

**What it does:**
- Interviews you to understand requirements
- Creates `specs/[feature]/requirements.md`
- Designs architecture in `specs/[feature]/design.md`
- Breaks work into `specs/[feature]/tasks.md`
- **Never writes implementation code** (only specs)

**Output:** Comprehensive specifications ready for implementation

### Taste (audit) - QA & Drift Detector
**Use when:**
- Before releases or deployments
- After major implementation work
- Suspecting documentation is stale
- Investigating "what changed?" questions
- Periodic quality checks (weekly/monthly)

**What it does:**
- Compares `specs/` vs actual implementation
- Checks `README.md` vs code reality
- Identifies stale or obsolete tasks
- Detects code quality issues
- Finds architectural violations

**Output:** Drift Report with prioritized recommendations

### Pipe (cc) - CLI Command Translator
**Use when:**
- You need a quick command but can't remember syntax
- Translating natural language to Git commands
- Generating shell commands for your environment
- Raycast-style "AI translate this" interactions

**What it does:**
- Accepts natural language input
- Returns a single executable command
- Adapts to your shell (Fish, Zsh, Bash)
- Works identically in terminal and Raycast

**Output:** Single-line command (no markdown, no chat)

## Required Context Loading

Before performing ANY task in this repository, agents MUST read:
- `@README.md` - Project overview and setup instructions
- `@AGENTS.md` (this file) - Orchestration rules and role definitions
- `@specs/` - Feature specifications (if they exist)

If working on a specific feature, also read:
- `@specs/[feature]/requirements.md` - What needs to be built
- `@specs/[feature]/design.md` - How it should be built
- `@specs/[feature]/tasks.md` - Work breakdown

## Workflow Examples

### Example 1: Starting a New Feature
```bash
# Step 1: Plan the feature (Menu)
plan
# Provides requirements, design, and tasks

# Step 2: Verify environment (Mise)
prep
# Ensures dependencies and setup are correct

# Step 3: Implement (Developer or Implementation Agent)
# Work through tasks.md

# Step 4: Audit before release (Taste)
audit
# Verifies specs match implementation
```

### Example 2: Quick Git Command
```bash
# Instead of googling "how to undo last commit"
cc git "undo last commit"
# Output: git reset --soft HEAD~1
```

### Example 3: Debugging Drift
```bash
# Something feels off...
audit
# Receives Drift Report showing README is stale and tests are missing
```

## Agent Permissions & Boundaries

### Mise (prep)
- ✅ Read all files
- ✅ Install dependencies (with confirmation)
- ✅ Run diagnostic commands
- ❌ Modify source code
- ❌ Change architecture

### Menu (plan)
- ✅ Read all files
- ✅ Create/edit files in `specs/`
- ✅ Ask clarifying questions
- ❌ Write implementation code
- ❌ Run build/test commands

### Taste (audit)
- ✅ Read all files
- ✅ Run linters, tests, static analysis
- ✅ Generate reports
- ❌ Auto-fix issues (only recommend)
- ❌ Modify code or specs

### Pipe (cc)
- ✅ Return commands based on natural language
- ❌ Execute commands (user must run them)
- ❌ Interactive multi-turn conversations

## Setting Up Aliases (Recommended)

Add to your shell config (`~/.config/fish/config.fish` or `~/.zshrc`):

```bash
# High-Lift Agents
alias prep="goose run --instruction-file ~/dev/comme-ca/prompts/roles/mise.md"
alias plan="goose run --instruction-file ~/dev/comme-ca/prompts/roles/menu.md"
alias audit="goose run --instruction-file ~/dev/comme-ca/prompts/roles/taste.md"

# Low-Lift CLI Tool
export PATH="$HOME/dev/comme-ca/bin:$PATH"  # Adds 'cc' to PATH
```

Then use simply:
```bash
prep    # Bootstrap environment
plan    # Create specs
audit   # Check for drift
cc git "command"  # Quick translations
```

## Integration with comme-ca

This repository uses the **comme-ca Intelligence System** for agent orchestration:
- **Repository:** `~/dev/comme-ca`
- **Prompts:** `~/dev/comme-ca/prompts/`
- **Wrapper:** `~/dev/comme-ca/bin/cc`

To install comme-ca:
```bash
git clone git@github.com:USERNAME/comme-ca.git ~/dev/comme-ca
export PATH="$HOME/dev/comme-ca/bin:$PATH"
```

For full documentation, see `~/dev/comme-ca/README.md`.

## Troubleshooting

**"cc command not found"**
- Ensure `~/dev/comme-ca/bin` is in your PATH
- Verify `~/dev/comme-ca/bin/cc` is executable (`chmod +x`)

**"Agent not following instructions"**
- Ensure agent is loading the correct persona file
- Check that `~/dev/comme-ca/prompts/roles/` exists
- Verify prompt file hasn't been corrupted

**"Specs don't match implementation"**
- Run `audit` to generate drift report
- Either update specs or fix code
- Re-run `audit` to verify alignment

## Customization

This `AGENTS.md` is a template from `~/dev/comme-ca/scaffolds/high-low/`. You can customize it for your project by:
- Adding project-specific agent roles
- Defining custom workflows
- Specifying additional context files to load

However, keep the **core roles** (Mise, Menu, Taste, Pipe) intact to maintain compatibility with the comme-ca system.

---

**Version:** 1.0.0
**Source:** comme-ca High-Low Agent System
**Last Updated:** 2025-11-18

For questions or issues with agent orchestration, see:
- `~/dev/comme-ca/README.md` - comme-ca documentation
- `~/dev/comme-ca/requirements.md` - comme-ca PRD
- `~/dev/comme-ca/prompts/roles/*.md` - Individual agent personas
