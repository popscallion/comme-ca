<!--
@id: design
@version: 1.4.0
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
  - Replaces `{clipboard}` with actual system clipboard content.
  - Replaces `{selection}` with currently selected text.
  - Replaces `{argument}` with CLI arguments.
- **Transpilation:**
  - **Claude:** Symlinks prompts to `~/.claude/commands`.
  - **OpenCode:** Runs prompts via `opencode run` using intent-based profiles (`flash`, `pro`).
  - **Gemini:** Transpiles Markdown prompts into TOML configuration files.
  - **Codex:** Pipes prompt content directly to stdin or via `codex exec`.
- **Dual-Model Routing:** The wrapper implements logic to route queries to either a "Fast" model (Cerebras 120b) or a "Smart" model (Haiku 4.5) based on user flags.

### 3. The "Template vs. Instance" Profile Pattern
To decouple Distro intent from Governor implementation:
*   **Distro (`comme-ca`):** Defines the *Intent* (e.g., `intent: cheap-fast`, `intent: deep-reasoning`) via `COMME_CA_PROFILE` flags.
*   **Governor (`comme-ci`):** Defines the *Backend* (e.g., `flash` maps to Gemini 3 via OpenCode Zen, `pro` maps to Sonnet 4.5).
*   **Benefit:** `comme-ca` remains agnostic to specific API keys and provider choices.

### 4. The Spec Pattern (Unit of Work)
The system rejects loose tasks in favor of structured, encapsulated contexts.
- **Encapsulation:** Every feature or bug lives in its own directory: `specs/feature-[slug]/` or `specs/bug-[slug].md`.
- **Mandatory Artifacts:** A spec is not valid without `REQUIREMENTS.md`, `DESIGN.md`, and `_ENTRYPOINT.md`.

### 5. The Inbox Pattern (Buffer)
To prevent context window pollution, the system uses a designated `_INBOX/` directory for raw dumps and sanitization.

### 6. Protocol Synchronization (Shim Pattern)
To handle the lifecycle of `comme-ca` as both a Distro and a Living Protocol:
- **Registry:** `~/.comme-ca/protocol/[version]` stores the canonical artifacts.
- **Shim:** Project-level `AGENTS.md` files are lightweight pointers (`@import`) to the Registry, preventing drift.
- **Harvest:** The `tune` role detects local process improvements and generates feedback for upstream integration.

## Naming Conventions (Strict)

### 1. Root Level
- **Meta-Documents (ALL CAPS):**
  - `README.md`, `LICENSE`, `AGENTS.md`
  - `REQUIREMENTS.md` (Constraints)
  - `DESIGN.md` (Architecture)
- **Special Files (Underscore + Caps):**
  - `_ENTRYPOINT.md` (Dashboard/Status)
- **Special Directories (Underscore + Caps):**
  - `_INBOX/` (Intake buffer)
  - `_ARCHIVE/` (Specs only)

### 2. Specification Directory (`specs/`)
- **Flat Structure:** Minimize nesting.
- **Prefixes Required:**
  - Features: `feature-[slug]/` (Directory)
  - Bugs: `bug-[slug].md` (Single File) OR `bug-[slug]/` (Directory if complex)
- **Feature Structure:**
  - `specs/feature-x/_ENTRYPOINT.md`
  - `specs/feature-x/REQUIREMENTS.md`
  - `specs/feature-x/DESIGN.md`
  - `specs/feature-x/_RAW/` (For chat logs, context)

### 3. General Rules
- **No inventions.** Use descriptive names.
- **Underscores reserved** for the special files listed above.
- **One special file per level.** (e.g., only one `_ENTRYPOINT.md` in root).
