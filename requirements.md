# Product Requirements Document (PRD): comme-ca
**The Intelligence Monorepo & Agent Orchestration System**

## 1. Purpose & Rationale
**comme-ca** is a centralized "Intelligence Monorepo." Unlike a dotfiles repository (which manages *configuration state*), comme-ca manages *operational logic, workflows, and prompts*.

It unifies two distinct modes of development into a single library:
1.  **Low-Lift ("Pipe"):** Stateless, single-purpose, low-latency CLI tools (e.g., "Translate this sentence into a Git command").
2.  **High-Lift ("Kitchen"):** Stateful, multi-step autonomous agent workflows for planning, maintenance, and bootstrapping.

**Core Philosophy:**
*   **Separation of Concerns:** Intelligence (prompts/roles) is decoupled from Infrastructure (dotfiles/env).
*   **Cross-Compatibility:** Prompts must work identically in a GUI (Raycast) and the Terminal (Goose/Claude via a wrapper).
*   **Single Source of Truth:** One repo defines how agents behave across all projects.

---

## 2. The "Culinary" Metaphor & Naming
To distinguish agent capabilities, this system uses specific naming conventions based on a professional kitchen workflow.

| Internal Name | User Alias | Former Name | Responsibility | Scope |
| :--- | :--- | :--- | :--- | :--- |
| **`cca`** | N/A | `ca` | **The Wrapper** | The CLI tool that executes Pipe prompts. |
| **`mise`** | `prep` | Initializer | **Setup** | Bootstrapping repos, ensuring tools/env are ready. |
| **`menu`** | `plan` | Clarifier | **Planning** | Requirements gathering, spec generation, architecting. |
| **`taste`** | `audit` | Maintainer | **QA/Sync** | Drift detection, code cleanup, doc synchronization. |

---

## 3. Architecture & Directory Structure
The repository `~/dev/comme-ca` must adhere to this strict structure:

```text
comme-ca/
├── README.md           # Documentation and alias definitions
├── requirements.md     # This PRD
├── bin/
│   ├── cca             # The executable wrapper script (Bash)
│   └── install         # Bootstrap installer script
├── prompts/
│   ├── pipe/           # LOW-LIFT: Single-shot, fast prompts
│   │   ├── _template.md   # Master template (Raycast compatible)
│   │   ├── git.md         # Git translator
│   │   ├── shell.md       # Shell translator
│   │   └── ...
│   └── roles/          # HIGH-LIFT: Persistent Agent Personas
│       ├── mise.md        # System prompt for 'prep'
│       ├── menu.md        # System prompt for 'plan'
│       └── taste.md       # System prompt for 'audit'
└── scaffolds/          # Distributable configurations for other repos
    └── high-low/
        ├── AGENTS.md      # The "Router" file for consumer repos
        └── CLAUDE.md      # Pointer to AGENTS.md
```

---

## 4. Component Specifications

### A. The CLI Wrapper (`bin/cca`)
A Bash script serving as the bridge between the user's terminal and the Markdown prompts.

**Requirements:**
1.  **Engine Agnostic:** Must default to `goose` but support `claude` (headless) via configuration.
2.  **Input Handling:** Must accept input via Argument (`cca git "undo"`) OR Stdin (`cat file | cca data-clean`).
3.  **Init Subcommand:** Must support `cca init` to bootstrap agent orchestration in the current directory:
    *   Check if `AGENTS.md` or `CLAUDE.md` already exist
    *   Copy scaffold files from `~/dev/comme-ca/scaffolds/high-low/`
    *   Print success message: "Initialized agent orchestration in $(pwd)."
4.  **The Raycast Shim:** The script must parse the Markdown prompt *before* sending it to the AI model to ensure compatibility with Raycast's placeholder syntax.
    *   Replace `{argument ...}` with user input.
    *   Replace `{selection ...}` with user input.
    *   Replace `{clipboard ...}` with user input.
    *   Replace `{shell_name}` with the active shell (e.g., `fish`, `zsh`).
    *   Replace `{os_name}` with `uname -s`.

### B. Low-Lift Prompts (`prompts/pipe/`)
These are "functions" written in Markdown.

**Requirements:**
1.  **Format:** Must use the Standard Header defined in `_template.md`.
2.  **Strict Output:** Instructions must enforce a single string output (no markdown blocks, no chat).
3.  **Raycast Compatibility:** Must use standard Raycast dynamic placeholders for inputs.

**Template Reference (`prompts/pipe/_template.md`):**
```markdown
<!--
@title: Universal Command Translator
@desc: Converts NL to single command string.
-->
# SYSTEM ROLE
You are a strict command-line translator.
1. Reply with exactly one command string and nothing else.
2. If impossible, output: echo "UNSUPPORTED"

# INPUT CONTEXT
OS: {os_name} | Shell: {shell_name}

# REQUEST
Translate this into a valid {OUTPUT_LABEL} command:
{argument name="Instruction" default="Last clipboard content"}
```

### C. High-Lift Roles (`prompts/roles/`)
These are "Personas" used by autonomous agents (Claude/Goose) when running in long-context modes.

1.  **`mise.md` (Alias: `prep`)**:
    *   **Role:** System bootstrapper.
    *   **Directives:** Check for git initialization, check for `AGENTS.md`, ensure `cca` is in PATH, validate directory structure.
2.  **`menu.md` (Alias: `plan`)**:
    *   **Role:** Architect and Requirements gatherer.
    *   **Directives:** Interactively interview user, create `specs/[feature]/requirements.md`, generate `design.md` and `tasks.md`. Never write code; only write specs.
3.  **`taste.md` (Alias: `audit`)**:
    *   **Role:** Quality Assurance and Drift Detector.
    *   **Directives:** Compare `specs/` vs `src/`. Check `README.md` vs `AGENTS.md`. Identify obsolete tasks. Output a "Drift Report."

### D. Scaffolding (`scaffolds/`)
Artifacts that allow *other* repositories to inherit intelligence from `comme-ca`.

1.  **`AGENTS.md`**: The constitution file copied into consumer projects. It explicitly defines:
    *   "For planning, load the persona from `~/dev/comme-ca/prompts/roles/menu.md`."
    *   "For quick CLI tasks, use the `cca` tool."
2.  **`CLAUDE.md`**: A symlink/pointer file directing Claude Code to read `AGENTS.md`.

### E. Bootstrap Installer (`bin/install`)
A Bash script that automates the installation and configuration of comme-ca.

**Requirements:**
1.  **Repository Check:** Verify if `~/dev/comme-ca` exists
2.  **Interactive Clone:** If not present, prompt user: "Clone comme-ca to ~/dev/comme-ca? [y/N]"
3.  **Clone Repository:** If confirmed, execute `git clone git@github.com:popscallion/comme-ca ~/dev/comme-ca`
4.  **Shell Detection:** Automatically detect Fish, Zsh, or Bash
5.  **Config Append:** Add PATH export and aliases (`prep`, `plan`, `audit`) to appropriate config file if not already present
6.  **Completion Notice:** Instruct user to restart shell or source config file

---

## 5. Implementation Roadmap

The implementing agent must perform the following steps:

1.  **Scaffold Structure:** Create the `comme-ca` directory tree.
2.  **Implement The Pipe (`cca`):** Write the Bash script with the Regex Shim logic. Make executable.
3.  **Create Templates:** Write the `_template.md`, `git.md`, and `shell.md` using the Raycast syntax.
4.  **Define Personas:** Write the `mise`, `menu`, and `taste` markdown system prompts.
5.  **Build Scaffolds:** Create the `high-low` folder with the master `AGENTS.md`.
6.  **Documentation:** Generate a `README.md` that documents the aliasing logic (`alias prep="goose run --instructions .../mise.md"`).

---

## 6. Success Criteria

*   **Test 1 (Low-Lift):** Running `cca git "create branch foo"` outputs `git checkout -b foo` instantly without markdown formatting.
*   **Test 2 (Compatibility):** The content of `prompts/pipe/git.md` can be pasted into Raycast "Create AI Command" and works without modification.
*   **Test 3 (High-Lift):** A user can launch an agent session using the `taste` persona to audit the `comme-ca` repo itself.
*   **Test 4 (Independence):** The repository does not contain dotfiles (configurations), only intelligence (prompts/scripts).
*   **Test 5 (Bootstrap):** Running `bin/install` successfully clones the repo, detects the shell, and configures PATH and aliases.
*   **Test 6 (Init):** Running `cca init` in a new directory successfully copies `AGENTS.md` and `CLAUDE.md` from scaffolds.