# comme-ca

Centralized repository for AI agent prompts, CLI tools, and orchestration workflows.

## Rationale

Lean, single source of truth for agent intelligence. Self-documenting, easy iteration, general purpose with automation guardrails against user error. Intelligence (prompts/roles) is decoupled from infrastructure (dotfiles/env).

---

## Installation

### 1. One-Line Installer (Recommended)
This script clones the repository and configures your shell (Bash, Zsh, or Fish) with the required aliases and PATH.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/popscallion/comme-ca/main/bin/install)"
```

*Alternatively, if you have already cloned the repo:*
```bash
./bin/install
```

### 2. Verify Installation
Restart your terminal, then run:
```bash
cca setup:list
```

### Dependencies
- **Goose** (Primary Runtime): [Install Goose](https://block.github.io/goose/docs/getting-started/installation)
- **Git** & **GitHub CLI (`gh`)**
- **Ripgrep (`rg`)** (for fast context searching)
- *Optional:* Claude Code (`npm i -g @anthropic-ai/claude-code`) or Crush CLI

## Usage

### CLI (Pipe)
```bash
cca <tool> "<instruction>"
```

**Examples:**
```bash
cca git "create branch feature/auth"
cca shell "find all JSON files"
```

### Agents (High-Lift)
```bash
prep   # System setup (mise)
plan   # Specs & architecture (menu)
audit  # QA & drift detection (taste)
```

### Context Utilities (Ad-Hoc)
```bash
clarify  # Design space explorer (Socratic interview)
what     # PRD generator from context
why      # Decision record/commit message generator
```

### Project Setup
```bash
cd <project>
cca init
```
Copies `AGENTS.md`, `CLAUDE.md`, and `GEMINI.md` to current directory.

---

## Architecture

### Directory Structure

```
comme-ca/
├── README.md
├── requirements.md
├── bin/
│   ├── cca                # CLI wrapper (renamed from ca)
│   └── install            # Bootstrap installer
├── prompts/
│   ├── pipe/              # Single-shot prompts
│   │   ├── _template.md
│   │   ├── git.md
│   │   └── shell.md
│   ├── roles/             # Agent personas
│       ├── mise.md        # System bootstrapper + git scaffolding
│       ├── menu.md        # Architect/planner
│       └── taste.md       # QA/drift detector
│   └── utilities/         # Ad-hoc context tools
│       ├── clarify.md     # Design explorer
│       ├── what.md        # PRD generator
│       └── why.md         # Decision recorder
└── scaffolds/
    ├── high-low/          # Agent orchestration files
    │   ├── AGENTS.md      # Router for consumer projects
    │   ├── CLAUDE.md      # Pointer to AGENTS.md
    │   └── GEMINI.md      # Pointer to AGENTS.md
    └── project-init/      # Git scaffolding templates
        ├── README.template.md
        ├── LICENSE.gpl.txt
        ├── LICENSE.mit.txt
        ├── gitignore.template
        ├── requirements.template.md
        └── design.template.md
```

---

## Modes

### Pipe Prompts (`cca`)

Translate natural language to executable commands instantly.

**How it works:**
1. Input: `cca git "undo last commit"`
2. Script reads `prompts/pipe/git.md`
3. Applies Raycast Shim (replaces `{argument}`, `{shell_name}`, etc.)
4. Forwards to `goose` (default) or `claude`
5. Output: `git reset --soft HEAD~1`

**Available prompts:**
- `cca git "<instruction>"` - Git/GitHub commands
- `cca shell "<instruction>"` - Shell commands

**Configuration:**
```bash
export COMME_CA_ENGINE=claude      # Default: goose
export COMME_CA_HOME=/custom/path  # Default: ~/dev/comme-ca
```

### Agent Role Prompts

Multi-step, stateful workflows for planning, setup, and auditing.

#### **mise** (`prep`) - System Bootstrapper & Git Scaffolding
**Responsibility:** Ensure development environments are ready and scaffold new projects.
Checks git initialization (offers to scaffold if missing), validates `AGENTS.md`, ensures tools are installed, provides system readiness report. Can interactively create new repositories with GitHub integration.

#### **menu** (`plan`) - Architect & Requirements Gatherer
**Responsibility:** Transform ideas into specifications (without writing code).
Interviews user, creates `specs/[feature]/{requirements,design,tasks}.md`, designs architecture.

#### **taste** (`audit`) - QA & Drift Detector
**Responsibility:** Ensure implementation matches specifications.
Compares `specs/` vs code, checks `README.md` vs reality, identifies stale tasks, detects quality issues.

### Context Utilities

#### **clarify** - Design Space Explorer
**Responsibility:** Refine vague ideas into concrete specs.
Conducts a Socratic interview to uncover hidden requirements and architectural preferences. Run this *before* `plan` or `what`.

#### **what** - Contextual PRD Generator
**Responsibility:** Crystallize a conversation into a Product Requirements Document (PRD) or Research Synthesis.
Acts as a "Seed" for the `menu` agent.

#### **why** - Contextual Decision Recorder
**Responsibility:** Capture the "Why" behind changes for commit messages or decision logs.
Run this *before* `wrap` to generate high-quality context for the handoff.

---

## Workflow Examples

### Example 1: Scaffolding a New Project
```bash
mkdir my-new-project && cd my-new-project
prep                                 # Detects no .git, offers scaffolding
# Interactive prompts:
# - Project name: My New Project
# - Visibility: [private] 
# - Create GitHub remote: [yes]
# - License: [GPL-3.0]
# 
# Creates: .git/, AGENTS.md, CLAUDE.md, README.md, LICENSE, 
#          .gitignore, specs/requirements.md, specs/design.md
# Commits and pushes to GitHub

plan                                 # Create feature specs
# (Implement features)
audit                                # Verify implementation matches specs
```

### Example 2: Validating Existing Project
```bash
cd existing-project
prep                                 # Detects .git, runs validation checks
# Output: System Readiness Report with pass/warn/fail status
```

### Example 3: Quick Git Translation
```bash
cca git "create branch feature/auth"
# Output: git checkout -b feature/auth

cca git "undo last 3 commits but keep changes"
# Output: git reset --soft HEAD~3
```

### Example 4: Shell Command Translation
```bash
cca shell "find all JSON files larger than 10MB"
# Output: find . -name "*.json" -size +10M

cca shell "list processes using port 8080"
# Output: lsof -i :8080
```

---

## Raycast Integration

All `prompts/pipe/*.md` files work directly in Raycast:

1. Raycast → Extensions → Script Commands
2. Create AI Command → Import from File
3. Select `~/dev/comme-ca/prompts/pipe/git.md`

The `cca` wrapper implements a "Raycast Shim" that parses placeholders (`{argument}`, `{shell_name}`, etc.), ensuring cross-platform compatibility.

---

## Configuration

### Environment Variables

```bash
COMME_CA_ENGINE   # AI engine: goose (default) or claude
COMME_CA_HOME     # Installation path (default: ~/dev/comme-ca)
```

---

## License



GNU General Public License v3.0
