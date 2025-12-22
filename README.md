# comme-ca

RepRap inspired, recursive repository for behavioral holons: AI agent prompts, CLI tools, and orchestration workflows.

## Rationale

Lean, single source of truth for agent intelligence. Self-documenting, easy iteration, general purpose with automation guardrails against user error. Intelligence (prompts/roles) is decoupled from infrastructure (dotfiles/env).

**"Roles not finding project context"**
- Create `DESIGN.md` for architecture documentation
- Create `REQUIREMENTS.md` for validation rules
- Roles automatically detect and use these files

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
- **Claude Code**: `npm i -g @anthropic-ai/claude-code` (Required for `cca` pipe commands)
- **Gemini CLI**: (Optional, for interactive agent sessions)
- **Git** & **GitHub CLI (`gh`)**
- **Ripgrep (`rg`)** (for fast context searching)

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

### Search Agent (`cca search`)
A unified search tool wrapping Haiku 4.5 (smart) and GPT-OSS-120b (fast).

**Usage:**
```bash
cca search "What is the latest context7 version?"  # Single Shot
cca search --interactive                           # Interactive REPL
cca search --resume                                # Resume last session
```

**Shortcuts (via `AGENTS.md` setup):**
- `?` → Interactive Search
- `,` → Resume Session

### Dashboard & Context
All work is tracked in `_ENTRYPOINT.md`.
- **Check Status:** `cat _ENTRYPOINT.md` to see the "Iteration Dashboard".
- **Handoff:** Run `wrap` to update the dashboard and save context before ending a session.
- **Inbox:** Use `_INBOX/` for raw notes and parallel work streams.

### Agents (High-Lift)
```bash
prep   # System setup (mise)
plan   # Specs & architecture (menu)
audit  # QA & drift detection (taste)
wrap   # Handoff & consolidation (pass)
tune   # Process reflection (tune)
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

## Workflows

### 1. Spec Workflow

#### Creating a New Spec
1.  **Create Folder/File:** `specs/feature-<name>/` or `specs/bug-<name>.md`
2.  **Initialize Files:**
    -   `_ENTRYPOINT.md`: Dashboard and status.
    -   `REQUIREMENTS.md`: "What" we are building.
    -   `DESIGN.md`: "How" we are building it.
3.  **Register:** Add the new spec to the Iteration Dashboard in the root `_ENTRYPOINT.md`.

#### Spec Disposition
- **Active/Ideation:** All specs (including ideas, research, and active features) live in the root of `specs/`.
- **_ARCHIVE:** Only for specs that were implemented but are now deprecated, or research spikes that are explicitly closed. Do not archive unimplemented ideas; keep them in the root context.

#### Working on a Spec
1.  **Context Loading:** Always read the spec's `REQUIREMENTS.md` and `DESIGN.md` before starting work.
2.  **Task Tracking:**
    -   Update the local `_ENTRYPOINT.md` dashbaord.
3.  **Verification:** Verify changes against the REQUIREMENTS before marking complete.

#### Archiving a Spec (Deprecated/Dead Code Only)
1.  **Verify:** Ensure no active code depends on this spec. Run `git log` to confirm implementation status.
2.  **Move:** Move the folder to `specs/_ARCHIVE/`.
3.  **Consolidate:** Update root `REQUIREMENTS.md` or `DESIGN.md` if the feature introduced permanent system changes.

### 2. Inbox Workflow (Parallel Iteration)

Use `_INBOX/` to isolate context and prevent pollution of the main source tree.

#### Structure
```
_INBOX/
└── <topic-key>/          # e.g., "deadlock-debugging"
    └── <date-tag>/       # e.g., "2025-12-21"
        ├── evidence/     # Screenshots, logs, dumps
        └── notes.md      # Analysis
```

#### Process
1.  **Dump:** Place raw logs or "stream of consciousness" notes in the inbox folder.
2.  **Analyze:** Use the inbox context to formulate a plan.
3.  **Promote:** If the work results in a code change or new spec, create the appropriate files in `specs/` or `src/`.
4.  **Preserve:** Do not delete the inbox content; it serves as a historical record.

### 3. Documentation Sync

-   **Drift Check:** Run `cca audit` (or use the `taste` role) to verify that `AGENTS.md` and root docs match the codebase state.
-   **Dashboard Accuracy:** Ensure `_ENTRYPOINT.md` accurately reflects the **NEXT** action.

### 4. Role Development Workflow

When modifying `prompts/roles/`:
1.  **Edit:** Modify the markdown files.
2.  **Test:** Use `cca` or a fresh agent session to verify the role behaves as expected.
3.  **Release:** Changes are immediate for the local repo. To distribute, update `scaffolds/`.

---

## Architecture

### Directory Structure

```
comme-ca/
├── _ENTRYPOINT.md      # Iteration Dashboard & Context Handoff
├── _INBOX/             # Intake Buffer
├── README.md           # Documentation & Workflows
├── REQUIREMENTS.md     # PRD & Product Rules
├── DESIGN.md           # Architecture & Patterns
├── bin/
│   ├── cca             # CLI wrapper (renamed from ca)
│   └── install         # Bootstrap installer
├── specs/              # Feature Specifications
│   ├── feature-<name>/ # Feature context
│   │   ├── _ENTRYPOINT.md
│   │   ├── _RAW/       # Raw context (logs, chats)
│   │   ├── REQUIREMENTS.md
│   │   └── DESIGN.md
│   └── bug-<name>.md   # Self-contained bug spec
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
4. Forwards to `claude`
5. Output: `git reset --soft HEAD~1`

**Available prompts:**
- `cca git "<instruction>"` - Git/GitHub commands
- `cca shell "<instruction>"` - Shell commands

**Configuration:**
```bash
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
Compare `specs/` vs code, checks `README.md` vs reality, identifies stale tasks, detects quality issues.

#### **tune** (`retro`) - Process Engineer & Reflector
**Responsibility:** Analyze session history to identify failures, pivots, and successful patterns.
Generates `session_reflection.md` to optimize workflow and role definitions. Use interactively or before handoff.

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
#          .gitignore, specs/REQUIREMENTS.md, specs/DESIGN.md
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
