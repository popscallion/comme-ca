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
| **Tune (retro)** | `tune` | `/tune` (Claude/Gemini) | Process reflection, session analysis, workflow optimization |
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
- `@_ENTRYPOINT.md` - Iteration Dashboard and status
- `@README.md` - Workflows and procedures
- `@DESIGN.md` - Technical architecture, workflows, dependencies
- `@REQUIREMENTS.md` - Constraints, validation rules, quality gates
- `@_INBOX/` - Intake buffer for loose notes and requests
- `@specs/` - Feature specs (`feature-*` or `bug-*`)
- `@specs/_ARCHIVE/` - Deprecated/Legacy specs (Reference only)

**Create these files to define project-specific behavior.** The roles will execute validation rules from REQUIREMENTS.md, follow workflows from DESIGN.md, and track progress in _ENTRYPOINT.md.

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

## Universal Directives

These high-level constraints apply to ALL agents (Mise, Menu, Taste, Wrap) and ALL generated artifacts.

1.  **Tone & Style:**
    *   **Neutral:** Maintain a professional, objective, and non-conversational tone.
    *   **Concise:** Avoid filler, politeness markers ("Please," "Thank you"), and robotic preamble ("Here is the code").
    *   **No Emojis:** Do NOT use emojis in filenames, code comments, commit messages, or technical documentation (except where explicitly part of a user-facing UI).

2.  **Naming Conventions:**
    *   **Descriptive:** Use clear, descriptive names.
    *   **Strict Prefixes:** Feature specs MUST start with `feature-`. Bug specs MUST start with `bug-`.
    *   **Special Files:** Use `_UNDERSCORE` prefix for special system files (`_ENTRYPOINT`, `_INBOX`, `_RAW`, `_ARCHIVE`). Only ONE per level.
    *   **Capitalization:** Use ALL CAPS for meta-documents (`README`, `LICENSE`, `DESIGN`, `REQUIREMENTS`, `AGENTS`).
    *   **No Inventions:** Do NOT invent acronyms, "cute" project names, or abbreviations unless the user explicitly provides them.
    *   **Inference:** If a name is needed and none is provided, derive it strictly from the functional purpose.

3.  **Epistemic Integrity:**
    *   **No Hallucinations:** Do not reference files, URLs, or dependencies that do not exist.
    *   **Explicit Unknowns:** If a requirement is missing, explicitly list it as an "Open Question" rather than guessing.

4.  **Discovery First (Epistemic Rigor):**
    *   **List Before Read:** NEVER assume file paths. Always use `ls` (or equivalent discovery tools) to verify directory contents before attempting to read specific files.
    *   **Tool Agnostic:** Use the best available tools for discovery. If `Serena` or other advanced agents are detected, prioritize their capabilities over basic shell commands if appropriate.
    *   **Deep Verification:** Before declaring a feature "Implemented" or "Archived", verify its existence via `git log`, file search, or deep inspection. Do not rely solely on metadata status in markdown files.

5.  **Shell Portability:**
    *   **Detect First:** Do not assume a specific shell (Bash/Zsh/Fish). Detect or ask if generating shell-specific commands (exports, aliases, functions).
    *   **POSIX Preference:** Prefer standard POSIX syntax where possible.
    *   **Explicit Syntax:** When shell-specifics are needed (e.g., `set -Ux` vs `export`), provide the correct variant for the user's active shell.

5.  **Non-Interactive Contract:**
    *   **Constraint:** All CLI tools invoked by agents MUST accept a `--non-interactive` (or equivalent) flag or respect the `CI=true` / `NON_INTERACTIVE=true` environment variable.
    *   **Detection:** Agents MUST detect if they are running in a potentially non-interactive environment (e.g., within `cca pipe`) and force non-interactive modes to prevent hanging.

6.  **Workflow Triggers (Auto-Wrap):**
    *   **Trigger:** When the user signals completion (e.g., "we're done", "commit and push", "handoff"), ALL agents MUST initiate the `wrap` protocol.
    *   **Action:** Do not just exit. Run the hygiene checks, update `_ENTRYPOINT.md`, and perform the git commit sequence defined in `prompts/roles/pass.md`.

## Setting Up Aliases

Add to your shell config (`~/.config/fish/config.fish` or `~/.zshrc`):

```bash
# Low-Lift CLI Tool
export PATH="$HOME/dev/comme-ca/bin:$PATH"

# Search Agent Shortcuts (Fish)
abbr -a ? "cca search --interactive"
abbr -a , "cca search --resume"
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
