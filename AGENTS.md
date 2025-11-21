# Agent Orchestration & Roles
**Canonical Source: comme-ca Intelligence System**

This is the **source repository** for the comme-ca agent orchestration system. This document defines how autonomous agents (Claude Code, Goose, or other AI assistants) should operate within this repository. All agents must read and follow these orchestration rules.

> **Note:** This AGENTS.md serves dual purposes: (1) it governs agent behavior in this repo, and (2) it is the template that `cc init` copies to target projects. Changes here propagate to all new projects.

## Quick Reference

| Agent Role | Alias | Command | When to Use |
|:-----------|:------|:--------|:------------|
| **Mise (prep)** | `prep` | `goose run --instructions ~/dev/comme-ca/prompts/roles/mise.md` | Bootstrapping, environment setup, dependency checks |
| **Menu (plan)** | `plan` | `goose run --instructions ~/dev/comme-ca/prompts/roles/menu.md` | Requirements gathering, architecture planning, spec writing |
| **Taste (audit)** | `audit` | `goose run --instructions ~/dev/comme-ca/prompts/roles/taste.md` | Code review, drift detection, documentation sync |
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
- `@requirements.md` - Product requirements and roadmap

For target projects using comme-ca, also check for:
- `@specs/` - Feature specifications (if they exist)
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
alias prep="goose run --instructions ~/dev/comme-ca/prompts/roles/mise.md"
alias plan="goose run --instructions ~/dev/comme-ca/prompts/roles/menu.md"
alias audit="goose run --instructions ~/dev/comme-ca/prompts/roles/taste.md"

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

## Repository Structure (comme-ca)

This **is** the comme-ca Intelligence System source repository:
- **Prompts:** `prompts/roles/` - Agent persona definitions
- **Scaffolds:** `scaffolds/high-low/` - Templates for target projects
- **CLI:** `bin/cc` - Command translator wrapper
- **Installer:** `bin/install` - Bootstrap script

To use comme-ca in other projects:
```bash
# Clone (if not already installed)
git clone git@github.com:popscallion/comme-ca.git ~/dev/comme-ca

# Initialize a target project
cd /path/to/your/project
cc init
```

For full documentation, see `README.md` in this repository.

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

This is the **canonical AGENTS.md** for comme-ca. It is copied to target projects via `cc init`.

**For target projects:** Customize your copy by:
- Adding project-specific agent roles
- Defining custom workflows
- Specifying additional context files to load
- Updating the "Required Context Loading" section for your project structure

**For comme-ca development:** Changes to this file will propagate to all newly initialized projects. Keep the **core roles** (Mise, Menu, Taste, Pipe) intact to maintain system compatibility. Update `scaffolds/high-low/AGENTS.md` when making template-only changes that shouldn't apply to this repo.

---

**Version:** 1.0.1
**Repository:** github.com/popscallion/comme-ca
**Last Updated:** 2025-11-21

For questions or issues with agent orchestration, see:
- `README.md` - Project documentation
- `requirements.md` - Product requirements
- `prompts/roles/*.md` - Individual agent personas
