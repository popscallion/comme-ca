<!--
@id: search-agent-adr-session-mgmt
@version: 1.0.0
@model: gemini-2.0-flash
-->

# ADR: Search Agent Session Management

## Context
We are implementing `cca search`, a CLI wrapper for `claude` and `gemini` tools.
**Requirement:** Support interactive sessions and "resuming" (via `,` abbr) across terminal commands.
**Constraint:** We do not know the exact flag capabilities of the underlying `claude`/`gemini` CLIs regarding session persistence.

## Analysis of Options

### Decision 1: Session Persistence

#### Option A: Native Engine Persistence
Rely on the underlying tool's session flags (e.g., `claude --session-id 123`).
*   **Pros:** Minimal wrapper logic; leverages engine's optimized context management.
*   **Cons:** High risk. If the CLI is stateless (stdin->stdout), this is impossible. If the CLI handles sessions differently (e.g., interactive mode only), automation is brittle.
*   **Pre-req:** User must confirm `claude --help` supports `--session` or similar.

#### Option B: Wrapper-Managed Transcript (Recommended)
`cca` manages the state in `~/.cca/sessions/`.
*   **Mechanism:**
    1.  `cca search "query"` -> Creates `~/.cca/sessions/CURRENT.md`.
    2.  `cca search --resume "follow-up"` -> Reads `CURRENT.md`, appends "follow-up", sends *full context* to engine.
*   **Pros:**
    *   **Universal:** Works with any engine (stateless or stateful).
    *   **Persistable:** "Resume" works even after rebooting the terminal.
    *   **Auditable:** User can inspect the transcript file.
*   **Cons:**
    *   **Context Costs:** Re-sends full history every turn (higher token usage).
    *   **Complexity:** Bash script must handle file concatenation safely.

### Decision 2: System Prompt Injection

#### Option A: Native System Flag
Pass the prompt via `--system` or `--preamble`.
*   **Pros:** Strongest adherence (Model treats it as "God Mode" instructions).
*   **Cons:** Engine must support the flag.

#### Option B: Prepend Strategy ("User-System")
Concatenate `SYSTEM_PROMPT + TRANSCRIPT + NEW_QUERY` and pipe to stdin.
*   **Pros:** Guaranteed compatibility.
*   **Cons:** Weaker adherence (Model sees it as user text).
*   **Mitigation:** Use XML tags (`<system_instructions>...</system_instructions>`) to clearly demarcate.

## Recommendation

**Adopt Option B (Wrapper-Managed) for both.**

**Rationale:**
1.  **Robustness:** We control the state. We don't rely on undocumented CLI features.
2.  **UX:** We can implement the `,` resume logic exactly as desired (checking `~/.cca/sessions/latest`) without querying an opaque engine database.
3.  **Portability:** This logic works identically for `claude` and `gemini` backends.

**Proposed Workflow:**
1.  **New Session:** `cca search "foo"`
    - Loads `prompts/search_agents/haiku45.md`.
    - Saves to `~/.cca/sessions/session_[timestamp].md`.
    - Symlinks `~/.cca/sessions/latest` -> `session_[timestamp].md`.
    - Pipes (Prompt + Query) to Engine.
    - Appends (Query + Response) to Session File.
2.  **Resume:** `cca search --resume "bar"`
    - Reads `~/.cca/sessions/latest`.
    - Pipes (Prompt + History + "bar") to Engine.
    - Appends ("bar" + Response) to Session File.
