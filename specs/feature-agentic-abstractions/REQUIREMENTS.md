<!--
@id: feature-agentic-abstractions
@version: 1.0.0
@model: gemini-2.0-flash
-->
# REQUIREMENTS: Agentic Abstractions (Agents, Subagents, Skills, Tools)

## 1. Goal
Extend the `comme-ca` harness to explicitly model and exploit the abstractions of **Agents**, **Subagents**, **Skills**, and **Tools/MCPs**, ensuring compatibility across Claude Code, Gemini CLI, and OpenAI Codex.

## 2. Core Definitions (The "Agentic Contract")
- **Agent (Main):** Long-running, stateful role (`prep`, `plan`, `audit`). Maps to native sessions.
- **Subagent (Specialist):** Delegated worker with isolation/focus. Maps to native subagents (Claude) or recursive calls/threads (Gemini/Codex).
- **Skill (Reusable Procedure):** Named, reusable instruction block loaded into context. Maps to Claude Skills or prompt chunks.
- **Tool (MCP/Function):** Deterministic capability (e.g., Serena LSP, Git).

## 3. Functional Requirements
- **Normalization:** `AGENTS.md` must define these 4 concepts engine-agnostically.
- **Serena Refactor:**
  - Move/Refine `serena.md` to be a "Skill" (procedure) + "Tool" (capability).
  - Explicitly reference it in execution roles.
- **Subagent Pattern:**
  - Define `cca subagent:<name>` convention.
  - Create a reference subagent: `code-reviewer`.
- **Role Elevation:**
  - Update `mise`, `menu`, `taste` to identify as Agents.
  - `menu` (Plan) must be able to emit subagent tasks.
  - `taste` (Audit) should use subagents for heavy lifting.
- **Provider Alignment:**
  - `CLAUDE.md`: Map to native Subagents/Skills.
  - `GEMINI.md`: Map to CLI loops/recursion.
  - `CODEX.md`: Map to Assistants/Threads.

## 4. Constraints
- **Backward Compatibility:** No new heavy infrastructure.
- **Model Agnostic:** Patterns must work on all 3 engines.
- **Self-Documenting:** Architecture must be clear from the markdown files alone.

## 5. Source
Derived from User Prompt: "Extend the harness to model and exploit the abstractions of Agents, Subagents, Skills, and Tools/MCPs explicitly".
