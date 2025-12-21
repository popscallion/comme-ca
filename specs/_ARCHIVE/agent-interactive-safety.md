<!--
@id: agent-interactive-safety
@version: 1.0.0
@model: gemini-2.0-flash-exp
-->
# Spec: Agent Interactive Safety Protocols

## 1. Problem Statement
Autonomous agents (Gemini CLI, Claude Code) frequently get "stuck" in interactive shell sessions when executing wrapped commands (e.g., `cca git ...`). This occurs because:
1.  Underlying tools (`claude`, `gemini`) default to interactive REPL modes if standard input/output streams are ambiguous.
2.  Agents cannot easily send escape sequences (Ctrl+C, Ctrl+D) to break out of these nested shells.
3.  The `cca` wrapper propagates the interactive state without enforcing a "non-interactive" contract for piped commands.

**Impact:**
- Agents hang indefinitely, requiring manual user intervention to kill the process.
- Automations fail midway.
- "Wrap" protocols abort, leaving repos in inconsistent states.

## 2. Root Cause Analysis
*   **Ambiguous TTY:** When `cca` runs inside an agent's shell execution tool, `isatty` checks might return true (simulated TTY), causing the tool to launch in interactive mode.
*   **Missing Flags:** The `execute_engine` function in `cca` defaulted to `claude` (interactive) instead of `claude -p` (print/non-interactive).
*   **Input Handling:** If `cca` waits for `stdin` but the agent provides it via argument, logic might fall through to an interactive `read`, which hangs if the pipe is open but empty.

## 3. Proposed Solution

### A. The "Non-Interactive Contract" (Low-Level)
Define a strict protocol in `AGENTS.md` and `requirements.md`:
> **Constraint:** All CLI tools invoked by agents MUST accept a `--non-interactive` or equivalent flag (e.g., `-p` for Claude) or detect the `CI=true` / `NON_INTERACTIVE=true` environment variable.

### B. Hardening `bin/cca`
1.  **Explicit Mode Switching:**
    *   Detect if running in a TTY.
    *   If input is provided via args, FORCE non-interactive mode.
    *   Use `timeout` for execution to prevent infinite hangs.
2.  **Engine Configuration:**
    *   `claude` -> `claude -p` (Always, when used via `cca pipe`).
    *   `gemini` -> Ensure `run` command is used, not `chat` REPL.

### C. Environment Safeguards
*   Set `export CI=true` or `export NON_INTERACTIVE=1` in the agent's shell profile (`.bashrc` / `.zshrc` equivalent for the agent user).

## 4. Implementation Plan
1.  **Modify `bin/cca`:** Ensure `execute_engine` uses `-p` and handles input strictly. (Partially done).
2.  **Update `AGENTS.md`:** Add the "Non-Interactive Contract" to Universal Directives.
3.  **Test:** Create a "suicide test" where an agent tries to run `cca` in a way that usually hangs, and verify it exits with error instead of hanging.

## 5. Success Metrics
*   Zero incidents of agents hanging in `cca` sub-shells.
*   `cca git` returns exit code 0 or 1 immediately, never waiting for input.
