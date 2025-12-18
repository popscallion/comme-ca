# ENTRYPOINT (HANDOFF)

> **READ FIRST:** This file contains the critical context, recent changes, and immediate directives for the next agent or developer working on this repository.

## 1. The Situation
**Phase:** Debugging & Architecture Review.
We have paused the "fix-it" cycle for the **Interactive Hangup** issue (`cca audit` hanging) to perform a root cause analysis. The system is otherwise operational, with missing API keys fixed.

## 2. Recent Actions
*   **API Keys:** Fixed missing `TAVILY`, `PERPLEXITY`, etc. keys in `fish` config. (Requires shell reload).
*   **Wrapper Debugging:** Modified `bin/cca` to use `claude -p` (print mode) and `--dangerously-skip-permissions`, but hangs persist for complex roles.
*   **Root Cause Analysis:** Identified likely **Stdout Capture Deadlock**. `cca` captures stdout `$(...)`, swallowing interactive prompts from `claude`.

## 3. Critical Issue: The "Deadlock"
*   **Symptom:** `cca audit` hangs.
*   **Mechanism:** `claude` prints a prompt (e.g., "Allow tool?") to stdout. `cca` script captures it into a variable. The prompt is never displayed. `claude` waits for input on closed stdin.
*   **Conclusion:** The current `cca` wrapper architecture (simple bash capture) is incompatible with `claude`'s interactive-by-default behavior, even with `-p`.

## 4. System Capabilities
*   **Unified Search:** `cca search` (abbreviated `?`) launches the interactive agent.
*   **Agent Roles:** Standard roles (`/prep`, `/plan`, `/audit`, `/wrap`) defined in `AGENTS.md`.
*   **CLI Wrapper:** `bin/cca` provides the unified interface.

## 5. Next Orders (Strategic Pivot)
1.  **Isolate `claude` Behavior:** Run `claude` directly (without `cca` wrapper) with `tee` or redirection to see *exactly* what it outputs before hanging.
2.  **Re-architect Wrapper:** Consider rewriting `cca` to stream output (avoiding `$(...)` capture) or switch to a language (Python/Go) that handles PTYs/streams better than bash.
3.  **Verify Keys:** Ensure the API key fix works after shell reload.

## 6. Key References
*   `@specs/active/agent-interactive-safety.md` - Safety protocol spec.
*   `@bin/cca` - The problematic wrapper.

---
**Last Updated:** 2025-12-17
**Phase:** Root Cause Analysis
