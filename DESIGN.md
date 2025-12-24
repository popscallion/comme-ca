<!--
@id: design
@version: 1.3.0
@model: gemini-2.0-flash
-->
# DESIGN

## System Philosophy

`comme-ca` operates on a strict "Discovery First" and "Standardized Epistemology" basis. This extends to the file system structure itself.

## Architecture & Patterns

### 1. The Agentic Architecture
The system defines four core abstractions that apply across all AI engines:
- **Agents:** Long-running, stateful roles (e.g., `prep`, `plan`, `audit`) responsible for high-level goals.
- **Subagents:** Specialist workers delegated specific tasks with their own context (e.g., `code-reviewer`).
- **Skills:** Named, reusable procedures ("how to do X") loaded into the agent's context (e.g., `serena` for surgical editing and memory continuity).
- **Tools:** Deterministic capabilities (e.g., git, MCP tools).

### 2. The Wrapper Architecture (`bin/cca`)
The `cca` binary serves as the "Shim Layer" between static Markdown prompts and the execution engine.
- **Shim Layer:** Intercepts commands and performs **Placeholder Replacement** (Raycast-style) before sending text to the AI.
- **Transpilation:**
  - **Claude:** Symlinks prompts to `~/.claude/commands`.
  - **OpenCode:** Runs prompts via `opencode run` using intent-based profiles (`flash`, `pro`).
  - **Gemini:** Transpiles Markdown prompts into TOML configuration files.
  - **Codex:** Pipes prompt content directly to stdin or via `codex exec`.
- **Dual-Model Routing:** The wrapper implements logic to route queries to either a "Fast" model (Cerebras 120b) or a "Smart" model (Haiku 4.5) based on user flags.

### 3. The Spec Pattern (Unit of Work)
The system rejects loose tasks in favor of structured, encapsulated contexts.
- **Encapsulation:** Every feature or bug lives in its own directory: `specs/feature-[slug]/` or `specs/bug-[slug].md`.
- **Mandatory Artifacts:** A spec is not valid without `REQUIREMENTS.md`, `DESIGN.md`, and `_ENTRYPOINT.md`.

### 4. The Inbox Pattern (Buffer)
To prevent context window pollution, the system uses a designated `_INBOX/` directory for raw dumps and sanitization.

## Naming Conventions (Strict)

... [rest of rules preserved]