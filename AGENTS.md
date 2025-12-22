<!-- @protocol: comme-ca @version: 1.3.0 -->
# Agent Orchestration
**Powered by comme-ca Intelligence System**

This document defines how autonomous agents (Claude Code, Gemini CLI, Codex) should operate within this repository.

## The Agentic Architecture

comme-ca defines four core abstractions that apply across all AI engines. Agents must respect these logical categories, even if the implementation differs per provider.

| Concept | Definition | Claude Implementation | Gemini/Codex Implementation |
| :--- | :--- | :--- | :--- |
| **Agent** | A long-running, stateful role (e.g., `prep`, `plan`, `audit`) responsible for high-level goals. | Native Session / Agent SDK | CLI Loop / Assistant Thread |
| **Subagent** | A specialist worker delegated a specific task with its own context. | Native `Subagent` API | Recursive CLI Call (`gemini -c`) or Thread |
| **Skill** | A named, reusable procedure ("how to do X") loaded into the agent's context. | Native `Skill` | Prompt Context Injection |
| **Tool** | A deterministic capability (e.g., git, MCP tools). | MCP Tool | Function Call / MCP |

## Standard Roles (Agents)

| Role | Alias | Command | Responsibilities |
|:-----|:------|:--------|:-----------------|
| **Mise (prep)** | `prep` | `/prep` | **Agent.** Scaffolding & Setup. Uses `Serena` Skill for edits. |
| **Menu (plan)** | `plan` | `/plan` | **Agent.** Architecture & Specs. Delegates to `code-reviewer` Subagent. |
| **Taste (audit)** | `audit` | `/audit` | **Agent.** QA & Drift. Uses `Serena` Skill for fixes. |
| **Tune (retro)** | `tune` | `/tune` | **Agent.** Process Reflection. |
| **Pass (wrap)** | `wrap` | `/wrap` | **Agent.** Handoff & Closure. |

## Subagent Contract

**When to Delegate:**
1.  **Context Isolation:** The task requires reading massive logs or files that would pollute the main context.
2.  **Specialization:** The task requires a distinct persona (e.g., "Red Team Security Audit").

**Invocation Convention:**
- Use the CLI pattern: `cca subagent:<name> "<task>"`
- Example: `cca subagent:code-reviewer "Analyze src/auth.ts for leaks"`

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

5.  **Tooling Policy (Agency & Subprocesses):**
    *   **Policy:** Agents are expected to be autonomous but safe.
    *   **READ (Auto-Execute):** Agents MUST execute read-only tools (`ls`, `cat`, `git status`, `env`, `find`) **immediately and silently** to gather context. Do NOT ask for permission.
    *   **WRITE (Confirm):** Agents MUST ask for confirmation before executing modifying commands (`git init`, `npm install`, `write_file`), UNLESS specifically authorized by a wrapper flag (like `cca`'s pipe mode).
    *   **Skills:** If a Skill is available (e.g., `Serena`), agents MUST follow its procedures over ad-hoc methods.

6.  **Shell Portability:**
    *   **Detect First:** Do not assume a specific shell (Bash/Zsh/Fish). Detect or ask if generating shell-specific commands (exports, aliases, functions).
    *   **POSIX Preference:** Prefer standard POSIX syntax where possible.
    *   **Explicit Syntax:** When shell-specifics are needed (e.g., `set -Ux` vs `export`), provide the correct variant for the user's active shell.

7.  **Non-Interactive Contract:**
    *   **Constraint:** All CLI tools invoked by agents MUST accept a `--non-interactive` (or equivalent) flag or respect the `CI=true` / `NON_INTERACTIVE=true` environment variable.
    *   **Detection:** Agents MUST detect if they are running in a potentially non-interactive environment (e.g., within `cca pipe`) and force non-interactive modes to prevent hanging.

8.  **Workflow Triggers (Auto-Wrap):**
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

**Version:** 1.3.0
**Source:** comme-ca Intelligence System
**Last Updated:** 2025-12-22
