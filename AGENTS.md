<!-- @protocol: comme-ca @version: 1.2.0 -->
# Agent Orchestration
**Powered by comme-ca Intelligence System**

This document defines how autonomous agents (Claude Code, Gemini CLI) should operate within this repository.

## Standard Roles

| Role | Alias | Command | When to Use |
|:-----|:------|:--------|:------------|
| **Mise (prep)** | `prep` | `/prep` (Claude/Gemini) | Bootstrapping, environment setup, dependency checks |
| **Menu (plan)** | `plan` | `/plan` (Claude/Gemini) | Requirements gathering, architecture planning, spec writing |
| **Taste (audit)** | `audit` | `/audit` (Claude/Gemini) | Code review, drift detection, documentation sync |
| **Pass (wrap)** | `wrap` | `/wrap` (Claude/Gemini) | Handoff, session closure, context consolidation |
| **Pipe (cca)** | `cca` | `cca git "instruction"` | Quick CLI translations (low-latency, single commands) |

## Security & Sudo Philosophy

Agents act as extensions of the user (`l`). We employ a tiered security model for privileged access across the fleet.

### The Silver Standard (Transitional)
**Mechanism:** `NOPASSWD` sudo rules.
**Status:** **Active** on `flaca-linux` and trusted hosts.
**Protocol:**
- Agents operate freely.
- Security relies on SSH Key possession and Tailscale network security.
- Bootstrap requires **one-time** human intervention to authorize the agent.

### The Gold Standard (Target)
**Mechanism:** SSH Agent Authorization via YubiKey.
**Status:** **Planned** (See `specs/yubikey-auth/`).
**Protocol:**
- Agents request `sudo`.
- Human authorizes the **session** via a single physical YubiKey touch.
- Session remains open for 60 minutes (`timestamp_timeout=60`) for autonomous work.

### Critical Directives for Agents
1.  **Do NOT** ask the user for their password repeatedly. If you hit a password prompt, STOP and request the "Silver Standard" bootstrap.
2.  **Do NOT** enable `requiretty` in sudoers. Agents need non-interactive `sudo`.
3.  **DO** respect the "Read-Only Discovery" phase before attempting changes.

## Context Detection

Standard roles automatically detect and adapt to project documentation:

- `@design.md` - Technical architecture, workflows, dependencies
- `@requirements.md` - Constraints, validation rules, quality gates
- `@tasks.md` - Current work items and priorities
- `@specs/` - Feature specifications

**Create these files to define project-specific behavior.** The roles will execute validation rules from requirements.md, follow workflows from design.md, and track progress in tasks.md.

## Universal Directives

These high-level constraints apply to ALL agents (Mise, Menu, Taste, Wrap) and ALL generated artifacts.

1.  **Tone & Style:**
    *   **Neutral:** Maintain a professional, objective, and non-conversational tone.
    *   **Concise:** Avoid filler, politeness markers ("Please," "Thank you"), and robotic preamble ("Here is the code").
    *   **No Emojis:** Do NOT use emojis in filenames, code comments, commit messages, or technical documentation (except where explicitly part of a user-facing UI).

2.  **Naming Conventions:**
    *   **Descriptive:** Use clear, descriptive names (e.g., `user-authentication-service`).
    *   **No Inventions:** Do NOT invent acronyms, "cute" project names, or abbreviations unless the user explicitly provides them.
    *   **Inference:** If a name is needed and none is provided, derive it strictly from the functional purpose.

3.  **Epistemic Integrity:**
    *   **No Hallucinations:** Do not reference files, URLs, or dependencies that do not exist.
    *   **Explicit Unknowns:** If a requirement is missing, explicitly list it as an "Open Question" rather than guessing.

4.  **Shell Portability:**
    *   **Detect First:** Do not assume a specific shell (Bash/Zsh/Fish). Detect or ask if generating shell-specific commands (exports, aliases, functions).
    *   **POSIX Preference:** Prefer standard POSIX syntax where possible.
    *   **Explicit Syntax:** When shell-specifics are needed (e.g., `set -Ux` vs `export`), provide the correct variant for the user's active shell.

5.  **Workflow Triggers (Auto-Wrap):**
    *   **Trigger:** When the user signals completion (e.g., "we're done", "commit and push", "handoff"), ALL agents MUST initiate the `wrap` protocol.
    *   **Action:** Do not just exit. Run the hygiene checks, update `_ENTRYPOINT.md`, and perform the git commit sequence defined in `prompts/roles/pass.md`.

## Setting Up Aliases

Add to your shell config (`~/.config/fish/config.fish` or `~/.zshrc`):

```bash
# Low-Lift CLI Tool
export PATH="$HOME/dev/comme-ca/bin:$PATH"
```

Then configure your tools:
```bash
cca setup:all      # Configures both Claude Code and Gemini CLI
```

## Usage

```bash
/prep   # Bootstrap environment, install dependencies
/plan   # Create specifications, gather requirements
/audit  # Check for drift, validate compliance
/wrap   # Consolidate docs, commit, and generate handoff
cca git "command"  # Quick CLI translations
```

## Integration with comme-ca

- **Repository:** `~/dev/comme-ca`
- **Prompts:** `~/dev/comme-ca/prompts/roles/`
- **CLI Wrapper:** `~/dev/comme-ca/bin/cca`

For full documentation: `~/dev/comme-ca/README.md`

---

**Version:** 1.2.0
**Source:** comme-ca Intelligence System
**Last Updated:** 2025-12-16