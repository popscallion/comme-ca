# comme-ca

Centralized repository for AI agent prompts, CLI tools, and orchestration workflows.

## Rationale

Lean, single source of truth for agent intelligence. Self-documenting, easy iteration, general purpose with automation guardrails against user error. Intelligence (prompts/roles) is decoupled from infrastructure (dotfiles/env).

---

## Installation

**One-liner:**
```bash
curl -sL https://raw.githubusercontent.com/popscallion/comme-ca/main/bin/install | bash
```

**Manual:**
```bash
git clone git@github.com:popscallion/comme-ca ~/dev/comme-ca
export PATH="$HOME/dev/comme-ca/bin:$PATH"

# Add aliases (Fish example; use ~/.zshrc or ~/.bashrc for Zsh/Bash)
cat >> ~/.config/fish/config.fish <<'EOF'
alias prep="goose run --instructions ~/dev/comme-ca/prompts/roles/mise.md"
alias plan="goose run --instructions ~/dev/comme-ca/prompts/roles/menu.md"
alias audit="goose run --instructions ~/dev/comme-ca/prompts/roles/taste.md"
export PATH="$HOME/dev/comme-ca/bin:$PATH"
EOF
```

---

## Usage

### CLI (Pipe)
```bash
ca <tool> "<instruction>"
```

**Examples:**
```bash
ca git "create branch feature/auth"
ca shell "find all JSON files"
```

### Agents (High-Lift)
```bash
prep   # System setup (mise)
plan   # Specs & architecture (menu)
audit  # QA & drift detection (taste)
```

### Project Setup
```bash
cd <project>
ca init
```
Copies `AGENTS.md` and `CLAUDE.md` to current directory.

---

## Architecture

### Directory Structure

```
comme-ca/
├── README.md
├── requirements.md
├── bin/
│   ├── ca                 # CLI wrapper (renamed from cc)
│   └── install            # Bootstrap installer
├── prompts/
│   ├── pipe/              # Single-shot prompts
│   │   ├── _template.md
│   │   ├── git.md
│   │   └── shell.md
│   └── roles/             # Agent personas
│       ├── mise.md        # System bootstrapper
│       ├── menu.md        # Architect/planner
│       └── taste.md       # QA/drift detector
└── scaffolds/
    └── high-low/
        ├── AGENTS.md      # Router for consumer projects
        └── CLAUDE.md      # Pointer to AGENTS.md
```

---

## Modes

### Pipe Prompts (`ca`)

Translate natural language to executable commands instantly.

**How it works:**
1. Input: `ca git "undo last commit"`
2. Script reads `prompts/pipe/git.md`
3. Applies Raycast Shim (replaces `{argument}`, `{shell_name}`, etc.)
4. Forwards to `goose` (default) or `claude`
5. Output: `git reset --soft HEAD~1`

**Available prompts:**
- `ca git "<instruction>"` - Git/GitHub commands
- `ca shell "<instruction>"` - Shell commands

**Configuration:**
```bash
export COMME_CA_ENGINE=claude      # Default: goose
export COMME_CA_HOME=/custom/path  # Default: ~/dev/comme-ca
```

### Agent Role Prompts

Multi-step, stateful workflows for planning, setup, and auditing.

#### **mise** (`prep`) - System Bootstrapper
**Responsibility:** Ensure development environments are ready.
Checks git initialization, validates `AGENTS.md`, ensures tools are installed, provides system readiness report.

#### **menu** (`plan`) - Architect & Requirements Gatherer
**Responsibility:** Transform ideas into specifications (without writing code).
Interviews user, creates `specs/[feature]/{requirements,design,tasks}.md`, designs architecture.

#### **taste** (`audit`) - QA & Drift Detector
**Responsibility:** Ensure implementation matches specifications.
Compares `specs/` vs code, checks `README.md` vs reality, identifies stale tasks, detects quality issues.

---

## Workflow Examples

### Example 1: Starting a New Project
```bash
prep                                 # Verify environment
plan                                 # Create specs
# (Implement tasks)
audit                                # Verify specs match implementation
```

### Example 2: Quick Git Translation
```bash
ca git "create branch feature/auth"
# Output: git checkout -b feature/auth

ca git "undo last 3 commits but keep changes"
# Output: git reset --soft HEAD~3
```

### Example 3: Shell Command Translation
```bash
ca shell "find all JSON files larger than 10MB"
# Output: find . -name "*.json" -size +10M

ca shell "list processes using port 8080"
# Output: lsof -i :8080
```

---

## Raycast Integration

All `prompts/pipe/*.md` files work directly in Raycast:

1. Raycast → Extensions → Script Commands
2. Create AI Command → Import from File
3. Select `~/dev/comme-ca/prompts/pipe/git.md`

The `ca` wrapper implements a "Raycast Shim" that parses placeholders (`{argument}`, `{shell_name}`, etc.), ensuring cross-platform compatibility.

---

## Configuration

### Environment Variables

```bash
COMME_CA_ENGINE   # AI engine: goose (default) or claude
COMME_CA_HOME     # Installation path (default: ~/dev/comme-ca)
```

---

## License

MIT
