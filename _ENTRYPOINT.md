# ENTRYPOINT (HANDOFF)

> **READ FIRST:** This file contains the critical context, recent changes, and immediate directives for the next agent or developer working on this repository.

## 1. The Situation
We are in the **Meta-Refinement** phase, but currently troubleshooting a **Critical Tool Failure** in the `wrap` (Pass) agent. The agent is generating handoff text but failing to commit it to disk, causing state drift.

## 2. Recent Actions
*   **Bug Reporting:** Created `specs/active/context/bug-wrap-recursion-fail.md` detailing the silent failure of the wrap workflow.
*   **Documentation:** Created specs for `Atomic Prompt-Templates` and `Lab-Distro Sync` (pending implementation).

## 3. Next Orders
*   **CRITICAL FIX:** Investigate and fix the `prompts/roles/pass.md` logic to ensure it writes files and commits BEFORE outputting the handoff text.
*   **Resume:** Once fixed, proceed with `clarify` -> `atomic-prompt-templates.md`.

## 4. Key References
*   `@specs/active/context/bug-wrap-recursion-fail.md` - The forensic evidence of the bug.
*   `@prompts/roles/pass.md` - The suspected faulty prompt.
*   `RAW_search-agent.md` - User's raw requirements for the new Search Agent.

---
**Last Updated:** 2025-12-12 18:35
**Previous:** Meta-Refinement Sprint<!--
@id: search-agent-implementation
@version: 1.0.0
@model: gemini-2.0-flash
-->
# Discussion: Native Search Agent Implementation in Comme-ca

## 1. Context
We need to expose a **Search Agent** capability within the `comme-ca` ecosystem.
- **Goal:** Allow agents (Claude/Gemini) and users (human via shell) to execute high-quality, research-grade search queries.
- **Source:** We have a proven "Haiku 4.5" prompt in `comment-dit-on` (the private lab repo).
- **Constraints:**
    - Must work with `cca` scaffolding but not bloat `cca` itself.
    - Must allow "headless" execution for agents (returning raw text/JSON).
    - Must allow "interactive" execution for humans (chat-like experience).
    - Must leverage `claude -p` (headless mode) with specific MCP whitelisting.

## 2. Options Analysis

### Option A: `bin/search` Script (Recommended)
Create a standalone shell script `bin/search` (or `bin/haiku`) in `comme-ca`.

**Pros:**
*   **Decoupled:** `cca` remains a dumb pipe. `search` contains the specific flags (`--allowedTools`, `--mcp-config`, etc.).
*   **Universal:** Can be called by humans (`search "query"`) or agents (`run_shell_command("search 'query'")`).
*   **Maintainable:** The complex `claude` invocation logic lives in one place.
*   **Configurable:** Can detect flags (`--json`, `--verbose`) and pass them to `claude`.

**Cons:**
*   Another binary to manage in `$PATH`.

### Option B: `cca` Subcommand (`cca search`)
Implement directly in `bin/cca` switch statement.

**Pros:**
*   Single entry point.
*   Easy distribution (part of the main wrapper).

**Cons:**
*   **Context Pollution:** `cca` becomes aware of specific tools/prompts.
*   **Fragile:** Hardcoding `comment-dit-on` paths inside `cca` breaks if directory structure changes.

### Option C: Utility Prompt Only (`prompts/utilities/search.md`)
Just a markdown file telling agents "To search, run this huge `claude -p ...` command string".

**Pros:**
*   Zero code.

**Cons:**
*   **Error Prone:** Agents hallucinate flags or pathing.
*   **Verbose:** Agents must output long command strings every time.

## 3. The "Haiku 4.5" Adaptation
The original prompt (`haiku45.md`) is designed for **interactive chat** (Phase 1 Triage -> Phase 2 Search).
*   **Issue:** Agents calling this tool usually *already know* they need search (Phase 2). They don't need a "Triage" step asking "Do you want me to search?".
*   **Solution:** We need a **"Headless Adaptation"** mode.
    *   **Flag:** Pass a system prompt addition: `claude ... --append-system-prompt "FORCE_PHASE_2=true"`?
    *   **Prompt Edit:** Create a specific `haiku-headless.md` derived from the original but stripping the chatty parts?
    *   **Logic:** The script `bin/search` detects if it's running in a TTY.
        *   **TTY (Human):** Use standard Haiku prompt (Chat mode).
        *   **No-TTY (Agent):** Append "Skip Phase 1, output raw findings" instruction.

## 4. Proposed Architecture (`bin/search`)

```bash
#!/bin/bash
# usage: search "query" [--json]

# 1. Locate Prompt (synced from comment-dit-on)
PROMPT_FILE="$COMME_CA_HOME/prompts/utilities/search.md"

# 2. Configure Tools (Dynamic MCP config?)
# We might need a temp mcp-config.json if the system one is too broad/narrow.
ALLOWED_TOOLS="mcp__tavily,mcp__exa,mcp__perplexity,mcp__sequential_thinking"

# 3. Detect Mode
if [ -t 1 ]; then
  # Interactive (Human)
  # Uses standard Haiku prompt
  MODE_PROMPT=""
else
  # Headless (Agent)
  # Appends instruction to skip pleasantries
  MODE_PROMPT="--append-system-prompt 'OUTPUT_MODE: HEADLESS. Skip Triage. Execute Search immediately. Return concise report.'"
fi

# 4. Execute
echo "$QUERY" | claude -p \
  --system-prompt-file "$PROMPT_FILE" \
  $MODE_PROMPT \
  --allowedTools "$ALLOWED_TOOLS" \
  --model "claude-3-haiku-20240307" \
  --dangerously-skip-permissions
```

## 5. Integration with Fish Config
Your existing `llm` abbreviations (`,`, `?`) are great.
We can add:
```fish
abbr -a -- ?? 'search "%"'       # Quick deep search
abbr -a -- search-json 'search --json "%"' # For agents
```

## 6. Questions for Next Session
1.  **Prompt Sync:** Do we symlink `comment-dit-on/prompts/.../haiku45.md` to `comme-ca/prompts/utilities/search.md`? (Yes, aligns with "Strong Repo Linking").
2.  **MCP Config:** Does `claude` code need a specific `mcp-config.json` file generated, or can it inherit the user's default config? (Your fish config implies you have `claude` set up globally).
3.  **Model:** Confirm `claude-3-haiku` is sufficient, or do we want `sonnet` for the "Search Agent"? (Haiku is faster/cheaper for simple lookups).

---
**Next Actions:**
1.  Append this content to `_ENTRYPOINT.md`.
2.  Next session: Implement `bin/search` and the symlink strategy.
