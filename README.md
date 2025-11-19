# comme-ca
**The Intelligence Monorepo & Agent Orchestration System**

A centralized library of AI agent personas and low-latency CLI prompts, enabling consistent, cross-platform AI interactions.

---

## Overview

**comme-ca** (French: "like that") is a "High-Low" Intelligence System that unifies two distinct modes of AI interaction:

1. **Low-Lift ("Pipe"):** Fast, stateless CLI tools for single-shot commands
2. **High-Lift ("Kitchen"):** Stateful autonomous agent workflows for planning, setup, and QA

Unlike dotfiles repositories that manage *configuration*, comme-ca manages *intelligence* - the prompts, personas, and orchestration logic that power AI assistants.

### Core Philosophy

- **Separation of Concerns:** Intelligence is decoupled from infrastructure
- **Cross-Compatibility:** Prompts work identically in Raycast and the terminal
- **Single Source of Truth:** One repo defines agent behavior across all projects
- **Culinary Metaphor:** Roles are named after kitchen workflows (mise, menu, taste)

---

## Quick Start

### Installation

```bash
# Clone the repository
git clone git@github.com:USERNAME/comme-ca.git ~/dev/comme-ca

# Add cc (Pipe) to PATH
export PATH="$HOME/dev/comme-ca/bin:$PATH"

# Set up shell aliases (Fish example)
cat >> ~/.config/fish/config.fish <<'EOF'
# comme-ca aliases
alias prep="goose run --instruction-file ~/dev/comme-ca/prompts/roles/mise.md"
alias plan="goose run --instruction-file ~/dev/comme-ca/prompts/roles/menu.md"
alias audit="goose run --instruction-file ~/dev/comme-ca/prompts/roles/taste.md"
export PATH="$HOME/dev/comme-ca/bin:$PATH"
EOF

# Reload shell
source ~/.config/fish/config.fish
```

For Zsh/Bash, replace `~/.config/fish/config.fish` with `~/.zshrc` or `~/.bashrc`.

### Verify Installation

```bash
# Check that cc is available
which cc
# Should output: /Users/username/dev/comme-ca/bin/cc

# Test a Pipe prompt
cc git "create branch feature/test"
# Should output: git checkout -b feature/test

# Test a High-Lift agent
prep
# Should run the Mise bootstrapper agent
```

---

## Architecture

### Directory Structure

```
comme-ca/
├── README.md              # This file
├── requirements.md        # Product Requirements Document (PRD)
├── bin/
│   └── cc                 # The Pipe: CLI wrapper script
├── prompts/
│   ├── pipe/              # LOW-LIFT: Single-shot prompts
│   │   ├── _template.md      # Master template
│   │   ├── git.md            # Git command translator
│   │   └── shell.md          # Shell command translator
│   └── roles/             # HIGH-LIFT: Agent personas
│       ├── mise.md           # System bootstrapper (prep)
│       ├── menu.md           # Architect/Planner (plan)
│       └── taste.md          # QA/Drift detector (audit)
└── scaffolds/             # Distributable configurations
    └── high-low/
        ├── AGENTS.md         # Router file for consumer projects
        └── CLAUDE.md         # Pointer to AGENTS.md
```

---

## The Two Modes

### 1. Low-Lift: "The Pipe" (`cc`)

**Purpose:** Translate natural language to executable commands instantly.

**Use Cases:**
- "What's the Git command to undo my last commit?"
- "How do I find all TypeScript files in this directory?"
- "Generate a curl command to POST JSON to an API"

**How It Works:**
1. You provide natural language input: `cc git "undo last commit"`
2. The `cc` wrapper reads the appropriate prompt (e.g., `prompts/pipe/git.md`)
3. It applies the "Raycast Shim" to replace placeholders (`{argument}`, `{shell_name}`, etc.)
4. It forwards the processed prompt to `goose` (default) or `claude`
5. You receive a single executable command: `git reset --soft HEAD~1`

**Available Prompts:**
- `cc git "<instruction>"` - Git/GitHub commands
- `cc shell "<instruction>"` - Shell commands (Fish/Zsh/Bash)

**Raycast Compatibility:**
All prompts in `prompts/pipe/` can be copied directly into Raycast's "Create AI Command" and work without modification.

**Configuration:**
```bash
# Change AI engine (default: goose)
export COMME_CA_ENGINE=claude

# Change installation path (default: ~/dev/comme-ca)
export COMME_CA_HOME=/custom/path/to/comme-ca
```

### 2. High-Lift: "The Kitchen" (Agent Personas)

**Purpose:** Multi-step, stateful workflows for planning, setup, and auditing.

**Available Personas:**

#### Mise (prep) - System Bootstrapper
**Alias:** `prep`

**Responsibility:** Ensure development environments are ready.

**Use When:**
- Setting up a new machine
- Onboarding to a project
- Verifying dependencies
- Troubleshooting environment issues

**What It Does:**
- Checks git initialization
- Validates `AGENTS.md` exists
- Ensures tools are installed
- Provides "System Readiness Report"

**Example:**
```bash
prep
# Outputs checklist of pass/warn/fail items with fix suggestions
```

#### Menu (plan) - Architect & Requirements Gatherer
**Alias:** `plan`

**Responsibility:** Transform ideas into specifications (without writing code).

**Use When:**
- Starting a new feature
- Clarifying vague requirements
- Designing system architecture
- Breaking down work into tasks

**What It Does:**
- Interviews you to understand requirements
- Creates `specs/[feature]/requirements.md`
- Designs architecture in `specs/[feature]/design.md`
- Breaks work into `specs/[feature]/tasks.md`

**Example:**
```bash
plan
# Initiates interactive planning session
# Creates comprehensive specs in specs/ directory
```

#### Taste (audit) - QA & Drift Detector
**Alias:** `audit`

**Responsibility:** Ensure implementation matches specifications.

**Use When:**
- Before releases
- After major implementation work
- Suspecting documentation is stale
- Periodic quality checks

**What It Does:**
- Compares `specs/` vs actual code
- Checks `README.md` vs reality
- Identifies stale tasks
- Detects code quality issues
- Finds architectural violations

**Example:**
```bash
audit
# Outputs comprehensive drift report with prioritized issues
```

---

## Workflow Examples

### Example 1: Starting a New Project

```bash
# Step 1: Bootstrap the environment
prep
# Verifies git, dependencies, directory structure

# Step 2: Plan the feature
plan
# Creates specs/feature-name/{requirements,design,tasks}.md

# Step 3: Implement (developer or implementation agent)
# Work through the tasks

# Step 4: Audit before release
audit
# Verifies specs match implementation
```

### Example 2: Quick Git Translation

```bash
# Instead of googling syntax
cc git "create branch feature/auth"
# Output: git checkout -b feature/auth

cc git "undo last 3 commits but keep changes"
# Output: git reset --soft HEAD~3

cc git "view commits by author Alice"
# Output: git log --author="Alice" --oneline
```

### Example 3: Shell Command Translation

```bash
cc shell "find all JSON files larger than 10MB"
# Output: find . -name "*.json" -size +10M

cc shell "list processes using port 8080"
# Output: lsof -i :8080

cc shell "count lines in all Python files"
# Output: find . -name "*.py" -exec wc -l {} + | tail -1
```

---

## Integration with Projects

### Distributing Agent Intelligence

To enable comme-ca orchestration in another repository:

```bash
# Navigate to your project
cd ~/projects/my-project

# Copy scaffold files
cp ~/dev/comme-ca/scaffolds/high-low/AGENTS.md .
cp ~/dev/comme-ca/scaffolds/high-low/CLAUDE.md .

# Commit
git add AGENTS.md CLAUDE.md
git commit -m "Add comme-ca agent orchestration"
```

Now agents (Claude Code, Goose, etc.) in that project will:
- Read `AGENTS.md` for orchestration rules
- Use `prep`, `plan`, and `audit` aliases
- Have access to the Pipe (`cc`) for quick commands

### Customizing for Your Project

The scaffolded `AGENTS.md` can be customized to add:
- Project-specific agent roles
- Custom workflows
- Additional context files to load

However, keep the core roles (Mise, Menu, Taste) intact for compatibility.

---

## Raycast Integration

All `prompts/pipe/*.md` files are designed to work directly in Raycast:

1. Open Raycast → Extensions → Script Commands
2. Create AI Command → Import from File
3. Select `~/dev/comme-ca/prompts/pipe/git.md` (or any other)
4. The prompt works identically in Raycast and terminal

**Why?**
The `cc` wrapper implements a "Raycast Shim" that parses placeholders (`{argument}`, `{shell_name}`, etc.) before sending to the AI, ensuring cross-platform compatibility.

---

## Configuration

### Environment Variables

```bash
# Change AI engine (default: goose)
export COMME_CA_ENGINE=claude

# Change installation path (default: ~/dev/comme-ca)
export COMME_CA_HOME=/custom/path

# Goose-specific settings
export GOOSE_MODEL=claude-sonnet-4-5

# Claude-specific settings
export ANTHROPIC_API_KEY=your-key-here
```

### Shell Aliases (Fish)

```fish
# Add to ~/.config/fish/config.fish
alias prep="goose run --instruction-file ~/dev/comme-ca/prompts/roles/mise.md"
alias plan="goose run --instruction-file ~/dev/comme-ca/prompts/roles/menu.md"
alias audit="goose run --instruction-file ~/dev/comme-ca/prompts/roles/taste.md"
export PATH="$HOME/dev/comme-ca/bin:$PATH"
```

### Shell Aliases (Zsh/Bash)

```bash
# Add to ~/.zshrc or ~/.bashrc
alias prep="goose run --instruction-file ~/dev/comme-ca/prompts/roles/mise.md"
alias plan="goose run --instruction-file ~/dev/comme-ca/prompts/roles/menu.md"
alias audit="goose run --instruction-file ~/dev/comme-ca/prompts/roles/taste.md"
export PATH="$HOME/dev/comme-ca/bin:$PATH"
```

---

## Extending comme-ca

### Adding a New Pipe Prompt

1. Create `prompts/pipe/your-prompt.md`
2. Use the template from `prompts/pipe/_template.md`
3. Ensure it uses Raycast placeholder syntax
4. Test with `cc your-prompt "test input"`

**Template Structure:**
```markdown
<!--
@title: Your Prompt Title
@desc: Brief description
-->

# SYSTEM ROLE
You are a strict translator.
1. Reply with exactly one command.
2. No markdown, no explanations.

# INPUT CONTEXT
OS: {os_name} | Shell: {shell_name}

# REQUEST
{argument name="Instruction" default=""}

# OUTPUT FORMAT
A single command string.
```

### Adding a New Agent Persona

1. Create `prompts/roles/your-role.md`
2. Define clear responsibility and directives
3. Specify output format and guardrails
4. Add alias to your shell config

**Example:**
```markdown
# Your Role Name (alias)

**Persona:** You are...

## Core Responsibility
[Single clear purpose]

## Directives
1. [Step-by-step process]
2. ...

## Output Format
[Expected report structure]

## Guardrails
- Never [prohibited action]
- Always [required action]
```

---

## Troubleshooting

### `cc: command not found`

**Solution:**
```bash
# Add to PATH
export PATH="$HOME/dev/comme-ca/bin:$PATH"

# Verify
which cc
```

### Agent Not Following Instructions

**Solutions:**
1. Verify persona file exists: `ls ~/dev/comme-ca/prompts/roles/`
2. Check alias points to correct file: `alias prep`
3. Try full path: `goose run --instruction-file ~/dev/comme-ca/prompts/roles/mise.md`

### `cc` Returns Markdown Instead of Command

**Cause:** The AI isn't respecting "single command only" instruction.

**Solutions:**
1. Update prompt to be more explicit about output format
2. Try different AI engine: `export COMME_CA_ENGINE=claude`
3. Check if prompt file is corrupted

### Raycast Prompt Not Working

**Solutions:**
1. Ensure you copied the entire `.md` file content
2. Verify Raycast AI Command settings
3. Check placeholder syntax matches Raycast format

---

## Success Criteria (from PRD)

- [x] **Test 1:** `cc git "create branch foo"` outputs `git checkout -b foo` instantly
- [x] **Test 2:** `prompts/pipe/git.md` works in Raycast without modification
- [x] **Test 3:** `audit` can analyze the comme-ca repo itself
- [x] **Test 4:** Repository contains no dotfiles, only intelligence

---

## Contributing

### Development Workflow

1. Clone the repository
2. Make changes to prompts or scripts
3. Test with `cc` or agent aliases
4. Ensure backward compatibility
5. Update `README.md` if adding features
6. Commit with descriptive messages

### Versioning

- **Prompts:** Include `@version: X.Y.Z` in front matter
- **Scripts:** Include version in comments
- **Breaking Changes:** Major version bump (1.0.0 → 2.0.0)

---

## Related Projects

- **comme-ci** (formerly comme-ca): Dotfiles repository powered by chezmoi
- **Goose**: Autonomous AI agent platform
- **Claude Code**: AI-powered code assistant
- **Raycast**: macOS productivity tool with AI commands

---

## License

[Your License Here]

---

## Credits

**Author:** [Your Name]
**Created:** 2025-11-18
**Version:** 1.0.0

Inspired by the philosophy of mise en place: preparing everything before you begin.

---

## FAQ

### What's the difference between comme-ca and comme-ci?

- **comme-ci:** Dotfiles repository (configuration state, managed by chezmoi)
- **comme-ca:** Intelligence monorepo (prompts, agents, orchestration logic)

### Why the culinary metaphor?

Professional kitchens separate preparation (mise), menu design (planning), and quality control (tasting). This maps perfectly to agent workflows: setup, planning, and auditing.

### Can I use this without Goose?

Yes! The `cc` wrapper supports both `goose` and `claude` via `COMME_CA_ENGINE`. The High-Lift personas can be invoked directly by any AI that can read instruction files.

### How do I update comme-ca?

```bash
cd ~/dev/comme-ca
git pull origin main
```

Your shell aliases will automatically use the latest prompts.

### Can I use this in a team?

Absolutely! Fork the repo, customize for your team's workflows, and have everyone install it to the same path. Now all agents behave consistently across the team.

---

**For detailed technical specifications, see:** `requirements.md`
