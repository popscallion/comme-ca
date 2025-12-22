<!--
@id: design
@version: 1.1.0
@model: gemini-2.0-flash
-->
# DESIGN

## System Philosophy

`comme-ca` operates on a strict "Discovery First" and "Standardized Epistemology" basis. This extends to the file system structure itself.

## Architecture & Patterns

### 1. The Wrapper Architecture (`bin/cca`)
The `cca` binary serves as the "Shim Layer" between static Markdown prompts and the execution engine.
- **Shim Layer:** Intercepts commands and performs **Placeholder Replacement** (Raycast-style) before sending text to the AI.
  - Replaces `{clipboard}` with actual system clipboard content.
  - Replaces `{selection}` with currently selected text.
  - Replaces `{argument}` with CLI arguments.
- **Transpilation:**
  - **Claude:** Symlinks prompts to `~/.claude/commands`.
  - **Gemini:** Transpiles Markdown prompts into TOML configuration files.
  - **Codex:** Pipes prompt content directly to stdin.
- **Dual-Model Routing:** The wrapper implements hardcoded logic to route queries to either a "Fast" model (Cerebras 120b) or a "Smart" model (Haiku 4.5) based on user flags or query type.

### 2. The Spec Pattern (Unit of Work)
The system rejects loose tasks in favor of structured, encapsulated contexts.
- **Encapsulation:** Every feature or bug lives in its own directory: `specs/feature-[slug]/` or `specs/bug-[slug].md`.
- **Mandatory Artifacts:** A spec is not valid without:
  - `REQUIREMENTS.md` ("What"): Constraints, user stories, validation rules.
  - `DESIGN.md` ("How"): Architecture, data models, dependency changes.
  - `_ENTRYPOINT.md`: A localized dashboard tracking the specific status of *that* feature.

### 3. The Inbox Pattern (Buffer)
To prevent context window pollution and "messy" thoughts from entering the main codebase, the system uses a designated `_INBOX/` directory.
- **Raw Dump:** Users dump logs, stream-of-consciousness notes, or vague requests here.
- **Sanitization:** The `clarify` and `what` tools synthesize this chaos into structured `REQUIREMENTS.md`.
- **Promotion:** Clean results are promoted to `specs/`, while raw data stays in the inbox as a historical artifact.

## Naming Conventions (Strict)

To ensure machine-readability and reduce agent ambiguity:

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