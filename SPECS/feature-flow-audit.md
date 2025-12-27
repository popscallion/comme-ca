<!--
@id: flow-audit
@version: 1.0.0
@model: gemini-2.0-flash
-->

# Flow Audit & Lifecycle Verification

## Overview
This specification defines the validation strategy for the `comme-ca` ecosystem, ensuring seamless operation across the "Distro" (Tooling) -> "Consumer" (Project) lifecycle. It explicitly targets the handling of different project states, shell environments, and version mismatches.

## Requirements

### 1. The "Easy Onramp" (Automated Setup)
We MUST maintain a robust bootstrapping script (`bin/install`) that:
- **Environment Detection:** Identifies OS (Darwin/Linux), Shell (Fish/Zsh/Bash), and missing dependencies (`git`, `gh`, `rg`).
- **Path Configuration:** persistently adds `~/dev/comme-ca/bin` to the user's `$PATH` and sets `COMME_CA_HOME` in the shell configuration.
- **Idempotency:** Can be run multiple times without duplicating config entries or corrupting state.
- **Tool Handoff:** Automatically triggers `cca setup:all` to configure downstream AI tools.
- **Guidance:** Outputs clear "Next Steps" relevant to the detected state.

### 2. Shell Portability
- All generated commands (via `prep`, `cca`, `bin/install`) MUST respect the user's active shell.
- Zsh/Bash: Use `export VAR=val` and `source ~/.rc`.
- Fish: Use `set -Ux VAR val` and `source ~/.config/fish/config.fish`.

## Lifecycle Scenarios

The system MUST handle these specific state transitions gracefully:

| ID | Scenario Name | Context | Expected Behavior |
|:---|:---|:---|:---|
| **A** | **Cold Start** | New System, New Project. | Install `comme-ca` via script -> `prep` scaffolds project from scratch (Git + Specs). |
| **B** | **Stale Distro** | System has `comme-ca` v1.0, Upstream is v1.2. | `prep` functions but warns of updates. User runs `cca update` -> `prep` re-runs with v1.2 logic. |
| **C** | **Happy Path** | System v1.2, New Project. | `prep` detects empty folder -> Offers full scaffolding -> Result is v1.2 compliant. |
| **D** | **Brownfield Bootstrap** | Existing code, No `comme-ca`. | Install `comme-ca` -> `prep` detects code -> "Intelligent Triage" maps code to specs -> Adds `AGENTS.md`. |
| **E** | **Adoption** | Existing code, System Ready. | `prep` detects code + `.git` -> Skips git init -> "Intelligent Triage" -> Adds `AGENTS.md`. |
| **F** | **Drift/Upgrade** | Project has `AGENTS.md` v1.0, System is v1.2. | `audit` detects version mismatch -> Warns "Protocol Version Drift" -> Offers `cca setup:sync` or update instructions. |
| **G** | **Broken State** | `.git` exists but corrupt, or `SPECS/` empty. | `prep` detects anomaly -> Offers repair (re-init git or re-scaffold specs from context). |
| **H** | **Detached** | Project moved to machine w/o `comme-ca`. | Project remains readable (Standard Markdown). `prep` command fails (command not found), but no data loss. |
| **I** | **Nested/Monorepo** | Project inside another `comme-ca` project. | `prep` detects parent `.git` -> Asks: "Init new sub-project or treat as folder?" |

## Verification Plan

### 1. Automated Verification (Self-Correction)
The agent should be able to verify these behaviors autonomously using temporary directories:

*   **Test A (Scaffold):** `mkdir tmp/a && cd tmp/a && prep` -> Verify `AGENTS.md` created.
*   **Test E (Triage):** `mkdir tmp/e && touch tmp/e/notes.txt && cd tmp/e && prep` -> Verify `REQUIREMENTS.md` created from notes.
*   **Test F (Drift):** `mkdir tmp/f && echo "<!-- @version: 0.0.1 -->" > tmp/f/AGENTS.md && cd tmp/f && audit` -> Verify "Drift" warning in output.

### 2. Documentation Pull List (MCP)
When debugging or validating, the agent MUST pull these files:
- `bin/install` (Bootstrap logic)
- `prompts/roles/mise.md` (Scaffolding logic)
- `prompts/roles/taste.md` (Audit logic)
- `DOCS/SYNC_STRATEGY.md` (Architectural intent)
- `AGENTS.md` (Current versioning rules)

### 3. Manual Checklist (User)
1.  [ ] **Install:** Run `bin/install` on a fresh terminal session.
2.  [ ] **Verify Path:** Run `which cca` and `echo $COMME_CA_HOME`.
3.  [ ] **Scaffold:** Create `~/test-project`, run `prep`. Check `SPECS/` generated.
4.  [ ] **Triage:** Create `~/raw-project`, add `dump.txt`, run `prep`. Check `dump.txt` moved to `context/`.
5.  [ ] **Audit:** In `~/test-project`, change `src/` but not `SPECS/`. Run `audit`. Check for "Drift".

### 4. Debugging Prompt Template
Use this prompt when analyzing failures in the flow:

```markdown
I am analyzing a failure in the `comme-ca` lifecycle flow.
**Context:**
- Scenario: [A-I]
- Error: [Log output or observation]

**Checklist:**
1.  Did `prep` correctly identify the project state (New vs. Existing)?
2.  Did the shell command generation match the user's shell?
3.  Is `AGENTS.md` present, and does its version match the system?
4.  Did `codebase_investigator` reveal any hidden config files (.env, .git/config)?

**Docs to Reference:**
- `@prompts/roles/mise.md` (Expected behavior)
- `@SPECS/flow-audit/flow-audit.md` (This spec)

**Goal:** Identify if this is a Logic Error (Agent), a Script Error (Bash), or a User Error.
```
