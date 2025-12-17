<!--
@id: search-agent-recommendation
@version: 1.0.0
@model: gemini-2.0-flash
-->

# Search Agent Implementation: Recommendation

## Context
The user requires a search capability that serves two distinct personas:
1.  **The Agent (Tool User):** Needs `search_web` to clarify specs, fetch docs, and validate assumptions without polluting the context window or hallucinating.
2.  **The Human (CLI User):** Needs a low-friction "Raycast-like" experience to query the web from the terminal, with session persistence (`--session-id`, `--resume`).

## Analysis of Options

### Option A: Standalone `bin/search`
A dedicated script (e.g., Python or Go) that wraps an LLM + Search Tool.
*   **Pros:**
    *   Decoupled from `cca` core logic.
    *   Can be aliased easily (`s "query"`).
    *   Easier to maintain as a separate utility.
*   **Cons:**
    *   Another binary to manage/install.
    *   Duplication of LLM configuration (API keys, models) if not sharing `cca` config.

### Option B: Integrated `bin/cca search`
Adding a `search` command to the existing `cca` CLI wrapper.
*   **Pros:**
    *   **Unified Config:** Reuses `settings.json` (keys, models, system prompts).
    *   **Distribution:** Users get it automatically with `comme-ca` distro.
    *   **Agent Awareness:** Easier for other agents (Plan, Prep) to call `cca search` as a known internal tool.
*   **Cons:**
    *   Increases complexity of the `cca` wrapper.

## Recommendation: Option B (Integrated `bin/cca search`)

### Rationale
1.  **Distro Philosophy:** `comme-ca` is a "Distro". Core capabilities should be bundled. Search is a core capability for "Context Integrity" (verifying facts).
2.  **Tool Reuse:** Agents already expect `cca git ...`. Adding `cca search ...` follows the "Pipe" pattern defined in `AGENTS.md`.
3.  **Config DRY:** We avoid managing two sets of LLM configurations.

### Proposed Implementation Plan
1.  **Command:** `cca search "query" [--session-id ID] [--resume]`
2.  **Backend:** Use the existing `bin/cca` entry point.
3.  **Prompt:** Create `prompts/utilities/search.md` (similar to `clarify.md` but optimized for web retrieval + synthesis).
4.  **Behavior:**
    *   **Interactive:** Streams output to stdout.
    *   **Tool Mode:** Returns JSON or Markdown block for agent consumption.

## Next Steps
1.  Approve this recommendation.
2.  Create `prompts/utilities/search.md`.
3.  Update `bin/cca` to handle the `search` subcommand.
