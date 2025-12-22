<!--
@id: search-agent-adr-flexibility
@version: 1.0.0
@model: gemini-2.0-flash
-->

# ADR: Architectural Resilience of `cca search`

## Question
Does the "Wrapper-Managed State" architecture offer better flexibility (new providers) and robustness (API changes) compared to native integration?

## Analysis

### 1. Flexibility (Provider Swapping)
Our architecture implements the **Adapter Pattern**. `cca search` defines a stable interface (`--interactive`, `--resume`) that is independent of the backend.

| Layer | Responsibility | Benefit |
|:---|:---|:---|
| **Frontend (`cca`)** | Session files, flag parsing, prompt loading | **Write Once.** This logic is shared across all backends. |
| **Adapter (`execute_engine`)** | Formatting text for specific CLI | **Low Cost.** Adding `ollama` or `openai` requires just one new `case` statement. |
| **Backend (Engine)** | `claude`, `gemini`, `ollama` | **Interchangeable.** The wrapper treats them as "dumb pipes" for intelligence. |

**Verdict:** **High Flexibility.** We can mix and match models (e.g., use `haiku` for search, `local-llama` for summaries) without changing the user's workflow or the `cca` command syntax.

### 2. Robustness (API Insulation)
Vendor CLIs are volatile. They frequently rename flags (e.g., `--session` vs `--context`) or deprecate features.

*   **Native Approach:** If we relied on `claude --session-id`, and Anthropic renames it to `--conversation-id`, our script breaks. If they remove session storage to save cloud costs, our feature dies.
*   **Wrapper Approach:** We rely on the **lowest common denominator**: `stdin` -> `stdout`.
    *   We manage the history file.
    *   We manage the system prompt injection.
    *   **Result:** As long as the CLI can read text from a pipe and print text to the screen, our "Session" and "System Prompt" features will work *forever*.

**Verdict:** **Maximum Robustness.** We minimize the "API Surface Area" to just the raw text stream, insulating us from breaking changes in vendor tooling.

## Conclusion
Yes. By decoupling "State Management" from "Inference," we essentially build our own **universal agent runtime** that can ride on top of any CLI tool, current or future.
