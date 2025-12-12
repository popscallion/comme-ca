# Agent Orchestration & Roles
**Canonical Source: comme-ca Intelligence System**

This is the **source repository** for the comme-ca agent orchestration system. This document defines how autonomous agents (Claude Code, Gemini CLI) should operate within this repository. All agents must read and follow these orchestration rules.

> **Note:** This AGENTS.md serves dual purposes: (1) it governs agent behavior in this repo, and (2) it is the template that `cca init` copies to target projects. Changes here propagate to all new projects.

## Quick Reference

| Agent Role | Alias | Command | When to Use |
|:-----------|:------|:--------|:------------|
| **Mise (prep)** | `prep` | `/prep` (Claude/Gemini) | New project scaffolding, environment setup, dependency checks |
| **Menu (plan)** | `plan` | `/plan` (Claude/Gemini) | Requirements gathering, architecture planning, spec writing |
| **Taste (audit)** | `audit` | `/audit` (Claude/Gemini) | Code review, drift detection, documentation sync |
| **Pass (wrap)** | `wrap` | `/wrap` (Claude/Gemini) | Handoff, session closure, context consolidation |
| **Pipe (cca)** | `cca` | `cca git "instruction"` | Quick CLI translations (low-latency, single commands) |

## Context Utilities (Conversation Synthesis)

**Version:** Clarify v1.1.0, What v2.0.0, Why v2.0.0

| Tool | Alias | Command | When to Use |
|:-----|:------|:--------|:------------|
| **Clarify** | `clarify` | `cca clarify` | Live conversation: Socratic questioning to explore design space |
| **What** | `what` | `cca what` | Post-conversation: Generate PRD or Research Synthesis (forward-looking) |
| **Why** | `why` | `cca why` | Post-conversation: Generate Decision Record with narrative arc (backward-looking) |

### Recommended Workflows

**Standard Workflow (Post-Conversation):**
```bash
# After a conversation concludes:
what   # Produces: Requirements, constraints, assumptions, unknowns
why    # Produces: Context, journey, synthesis logic, trade-offs
# Result: Complete session documentation (what + why = enriched superset)
```

**Enhanced Workflow (Live + Post):**
```bash
# During conversation:
clarify   # Socratic questioning to resolve ambiguities

# After conversation:
what      # Detects clarify usage, documents which decisions came from exploration
why       # Detects clarify usage, documents unresolved questions
# Result: Session documentation + exploration audit trail
```

**Key Features (v2.0.0):**
- **What:** Epistemic markers (DEFINITIVE/INFERRED/SPECULATIVE), Open Questions section, SHALL requirements
- **Why:** Conversation Arc (Trigger/Pivot/Relationship), Synthesis Logic (tie-breaker reasoning), clarify integration
- **Combined:** 100% coverage of deprecated summarize.md + new formal structures

## Core Principles

1. **Separation of Concerns:** Intelligence (prompts/agents) is managed in `~/dev/comme-ca`, while project-specific code lives here.
2. **Single Source of Truth:** Agent behavior is defined in `~/dev/comme-ca/prompts/roles/`, not duplicated per project.
3. **Explicit Invocation:** Agents are called by role, not by generic "AI help me."
4. **Context Awareness:** Before working, agents must understand project structure, existing documentation, and current tasks.

## When to Use Each Agent

### Mise (prep) - System Bootstrapper & Git Scaffolding
**Use when:**
- Starting a brand new project from scratch
- Setting up this repository on a new machine
- Onboarding a new developer
- Verifying dependencies after a long break
- Troubleshooting "it works on my machine" issues

**What it does:**
- Detects if `.git/` exists and offers interactive scaffolding if missing
- Creates complete project structure with GitHub integration
- Scaffolds: README, LICENSE, .gitignore, AGENTS.md, CLAUDE.md, specs/
- Validates `AGENTS.md` exists in existing repos
- Ensures required tools are installed
- Verifies project structure
- Provides a "System Readiness Report"

**Output:** 
- For new projects: Interactive scaffolding with GitHub repo creation
- For existing projects: Pass/Warn/Fail checklist with actionable fixes

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

### Pass (wrap) - Handoff & Expediter
**Use when:**
- Ending a coding session
- Consolidating documentation before a commit
- Handing off work to another agent (or yourself later)

**What it does:**
- Updates `_ENTRYPOINT.md` (the "Handoff")
- Consolidates docs (`tasks.md`, `design.md`)
- Generates a precise handoff prompt

**Output:** A clean commit and a "Ticket" (handoff prompt) for the next agent

### Pipe (cca) - CLI Command Translator
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
- `@_ENTRYPOINT.md` - (Mandatory) The current project state and context handover
- `@README.md` - Project overview and setup instructions
- `@AGENTS.md` (this file) - Orchestration rules and role definitions
- `@requirements.md` - Product requirements and roadmap

For target projects using comme-ca, also check for:
- `@specs/` - Feature specifications (if they exist)
- `@specs/[feature]/requirements.md` - What needs to be built
- `@specs/[feature]/design.md` - How it should be built
- `@specs/[feature]/tasks.md` - Work breakdown

## Workflow Examples

### Example 1: Scaffolding a Brand New Project
```bash
mkdir my-new-project && cd my-new-project
prep
# Detects no .git, offers interactive scaffolding:
# - Project name: My New Project
# - Visibility: [private]
# - Create GitHub remote: [yes]
# - License: [GPL-3.0]
#
# Creates complete structure and pushes to GitHub

plan
# Create first feature specs

# Implement features

audit
# Verify implementation matches specs
```

### Example 2: Starting a New Feature in Existing Project
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

# Step 5: Wrap up session (Pass)
wrap
# Updates _ENTRYPOINT.md, commits, and output handoff prompt
```

### Example 3: Quick Git Command
```bash
# Instead of googling "how to undo last commit"
cca git "undo last commit"
# Output: git reset --soft HEAD~1
```

### Example 4: Debugging Drift
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
- ✅ Scaffold new projects (create .git, README, LICENSE, etc.)
- ✅ Create GitHub repositories (with user approval)
- ❌ Modify existing source code
- ❌ Change architecture of existing projects

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

### Pass (wrap)
- ✅ Read all files
- ✅ Update `_ENTRYPOINT.md` and documentation
- ✅ Stage and commit changes
- ❌ Write feature implementation code

### Pipe (cca)
- ✅ Return commands based on natural language
- ❌ Execute commands (user must run them)
- ❌ Interactive multi-turn conversations

## Setting Up Aliases (Recommended)

Add to your shell config (`~/.config/fish/config.fish` or `~/.zshrc`):

```bash
# Low-Lift CLI Tool
export PATH="$HOME/dev/comme-ca/bin:$PATH"  # Adds 'cca' to PATH
```

Then configure your tools:
```bash
cca setup:all      # Configures both Claude Code and Gemini CLI
```

Then use simply:
```bash
/prep   # In Claude or Gemini: Bootstrap environment
/plan   # In Claude or Gemini: Create specs
/audit  # In Claude or Gemini: Check for drift
/wrap   # In Claude or Gemini: Handoff session
cca git "command"  # Quick translations (Terminal)
```

## Multi-Tool Integration

Comme-ca prompts can be used with multiple AI CLI tools.

### Tool Status

| Tool | Status | Setup Command | Config Location |
|:-----|:-------|:--------------|:----------------|
| **Claude Code** | Primary | `cca setup:claude` | `~/.claude/commands/` |
| **Gemini CLI** | Primary | `cca setup:gemini` | `~/.gemini/commands/` |

### Managing Tools

```bash
# Check which tools are configured
cca setup:list

# Configure a tool
cca setup:claude
cca setup:gemini

# Check for drift (prompt changes not yet synced)
cca drift
```

### When to Use Each Tool

- **Claude Code**: IDE integration. Good for development workflows.
- **Gemini CLI**: Interactive CLI agent. Good for fast, contextual tasks.

### Drift Detection

When you modify prompts in `~/dev/comme-ca/prompts/roles/`, configured tools may become out of sync. The `cca drift` command detects this by comparing MD5 hashes.

```bash
# Check all tools for drift
cca drift

# If drift detected, re-run setup for affected tools
cca setup:claude  # Regenerates from current prompts
```

## Repository Structure (comme-ca)

This **is** the comme-ca Intelligence System source repository:
- **Prompts:** `prompts/roles/` - Agent persona definitions
- **Scaffolds:** `scaffolds/high-low/` - Templates for target projects
- **CLI:** `bin/cca` - Command translator wrapper
- **Installer:** `bin/install` - Bootstrap script

> **Contributor Note:** The core prompts in `prompts/utilities/` and `prompts/roles/` are managed upstream in the `comment-dit-on` Private Lab. Do not edit them directly here; they will be overwritten by the sync process.

To use comme-ca in other projects:
```bash
# Clone (if not already installed)
git clone git@github.com:popscallion/comme-ca.git ~/dev/comme-ca

# Initialize a target project
cd /path/to/your/project
cca init
```

For full documentation, see `README.md` in this repository.

## Troubleshooting

**"cca command not found"**
- Ensure `~/dev/comme-ca/bin` is in your PATH
- Verify `~/dev/comme-ca/bin/cca` is executable (`chmod +x`)

**"Agent not following instructions"**
- Ensure agent is loading the correct persona file
- Check that `~/dev/comme-ca/prompts/roles/` exists
- Verify prompt file hasn't been corrupted

**"Specs don't match implementation"**
- Run `audit` to generate drift report
- Either update specs or fix code
- Re-run `audit` to verify alignment

## Customization

This is the **canonical AGENTS.md** for comme-ca. It is copied to target projects via `cca init`.

**For target projects:** Customize your copy by:
- Adding project-specific agent roles
- Defining custom workflows
- Specifying additional context files to load
- Updating the "Required Context Loading" section for your project structure

**For comme-ca development:** Changes to this file will propagate to all newly initialized projects. Keep the **core roles** (Mise, Menu, Taste, Pipe) intact to maintain system compatibility. Update `scaffolds/high-low/AGENTS.md` when making template-only changes that shouldn't apply to this repo.

---

**Version:** 1.1.0
**Repository:** github.com/popscallion/comme-ca
**Last Updated:** 2025-11-23

For questions or issues with agent orchestration, see:
- `README.md` - Project documentation
- `requirements.md` - Product requirements
- `prompts/roles/*.md` - Individual agent personas
