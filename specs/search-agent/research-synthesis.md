<!--
@id: search-agent-research-synthesis
@version: 1.0.0
@model: gemini-2.0-flash
-->

# Research Synthesis: `cca search` vs. Sub-Agent Patterns

## Overview
This document analyzes the alignment between our proposed `cca search` architecture and the industry-standard "Sub-Agent" patterns identified in `@_SUBAGENT-RESEARCH.md`.

## Alignment Analysis

### 1. The Topology (Planner vs. Worker)
*   **Research:** Describes a "strong frontier model" (Planner) delegating tasks to "smaller, cheaper models" (Workers) to save cost and context.
*   **Our Architecture:** `cca search` is explicitly designed as the "Worker."
    *   **Planner:** The main agent (running `plan` or `clarify` via Claude Opus/Gemini Pro).
    *   **Worker:** `cca search` (running Haiku 4.5 or Flash).
*   **Verdict:** **Perfect Alignment.** We are implementing the "Coordinator-Dispatcher" pattern.

### 2. The Context Sandbox (Isolation)
*   **Research:** Emphasizes that sub-agents must have their "own sandboxed context" to prevent "polluting the context window of the main agent."
*   **Our Architecture:** `cca search` runs as a subprocess. It starts with *zero* context (except what is passed in args) and returns only the *distilled* JSON. The massive intermediate search results (raw HTML, Tavily logs) are discarded when the subprocess exits.
*   **Verdict:** **Strong Alignment.** This is the primary technical benefit of the wrapper approach.

### 3. Execution Mechanism (The "How")
*   **Research (Gemini):** Gemini CLI lacks `spawn_agent`. It relies on `run_shell_command` (executing a subprocess) where `GEMINI_CLI=1` is set.
*   **Research (Claude):** Claude Code has a native `run_agent` command.
*   **Our Architecture:** We are building a **universal shim**.
    *   For **Gemini**, `cca search` *is* the missing `spawn_agent` logic. It provides the structured entry point that the CLI lacks.
    *   For **Claude**, `cca search` wraps the *prompt complexity*. While `run_agent` exists, it requires you to supply the system prompt every time. `cca search` encapsulates the "Phase 1/2" logic, domain filtering, and output schema, so the Planner just says "search for X".
*   **Verdict:** **Strategic Add-on.** We fill a gap in Gemini and simplify usage in Claude.

## The "Wrapper-Managed State" Divergence

The research assumes sub-agents might be ephemeral (fire and forget).
*   **Divergence:** Our requirement for **Session Persistence** (the "Raycast-like" flow with `,` abbreviation) forces us to use **Wrapper-Managed State** (files on disk).
*   **Justification:** The research focuses on *autonomous* delegation. We are building for *hybrid* use (Human REPL + Agent Tool). The file-based history allows a Human to "pick up" where an Agent left off, or vice versa. This is a unique capability of the `cca` design.

## Implementation Implications

1.  **Environment Detection:** `bin/cca` should check `GEMINI_CLI=1` or `CLAUDE_AGENT=1` (hypothetical) to auto-enable `--json` mode?
    *   *Decision:* No, explicit flags (`--json`) are safer than implicit env var magic.
2.  **Model Routing:** The "Planner" (Main Agent) should be able to specify the sub-model.
    *   *Requirement:* `cca search` needs a `--model` flag so the Planner can choose `haiku` (complex) vs `flash` (fast).

## Recommendation
Proceed with the **Wrapper-Managed State** architecture. It supports the research's "Sandboxed Worker" pattern while adding the "Human Persistence" feature that raw sub-agents lack.
