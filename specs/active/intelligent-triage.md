<!--
@id: intelligent-triage
@version: 1.0.0
@model: gemini-2.0-flash
-->

# Intelligent Triage & Forensic Ingestion

## 1. Executive Summary
**One Sentence Pitch:** A "Drop-and-Forget" workflow that allows users to dump raw artifacts (logs, screenshots, brain dumps) anywhere, which the system then intelligently detects, organizes into a standard directory structure, and processes into actionable specifications without losing the original context.

**Target Audience:** Developers reporting bugs, Architects sketching ideas, and Project Managers dropping requirements.

**Core Value:** Eliminates the friction of "formatting" inputs before starting work. Ensures "Forensic Preservation" of the original user intent/evidence.

## 2. Requirements (The "What")

### Functional
1.  **The "Plan" Trigger:** The `plan` (Menu) agent SHALL automatically detect "loose" context files in the `specs/` root, `bugs/` directory, or (for new projects) the Project Root.
2.  **Forensic Ingestion:** Upon detection (or chat paste), the system SHALL:
    *   Create a named directory: `specs/[type]-[slug]/` (e.g., `specs/bug-login-crash/` or `specs/feat-dark-mode/`).
    *   Create a subdirectory: `specs/[type]-[slug]/context/`.
    *   **MOVE** the raw files into `context/`.
    *   **WRITE** chat logs/transcripts to `context/chat-dump-[timestamp].md`.
3.  **Analysis & Scaffolding:** The system SHALL read the `context/` folder to generate:
    *   `requirements.md` (using `what` logic).
    *   `design.md` (using `why` logic).
    *   `plan.md` (if actionable tasks exist).
4.  **Bootstrapping Parity:** The `prep` (Mise) agent SHALL use this same logic when initializing a new project from a folder of raw notes (Raw Context Mode).

### User Stories
- As a developer, I want to drag a `crash.log` and `screenshot.png` into `specs/` and run `plan`, so that the agent automatically sets up a bug-fixing workspace for me.
- As a user, I want to paste a long error trace into the chat, so that the agent saves it to a file before I lose it and uses it to diagnose the issue.

### Non-Functional
- **Safety:** The original files in `context/` MUST be treated as Read-Only / Immutable by the generation process.
- **Naming:** Directory slugs should be auto-generated from the content if not provided (e.g., inferring "login-crash" from the log file content).

## 3. Technical Constraints (The "How")

### Directory Structure Standard
```text
specs/
├── active/               # (Optional organization)
├── bug-login-crash/      # The Unit of Work
│   ├── context/          # THE TRUTH (Raw inputs)
│   │   ├── crash.log
│   │   ├── screenshot.png
│   │   └── chat-transcript.md
│   ├── requirements.md   # The Definition (Generated)
│   ├── design.md         # The Solution (Generated)
│   └── tasks.md          # The Execution (Generated)
```

### Stack & Tools
- **Agent:** `Menu` (plan) and `Mise` (prep).
- **Format:** Standard Markdown with `@id/@version` metadata.

## 4. Assumptions & Defaults
- **Assumption:** Users prefer "Magic" folder organization over manual file management.
- **Default:** If the input type is unclear, default to `feat-` (Feature) unless keywords like "error", "crash", "bug" are detected (then `bug-`).

## 5. Open Questions
- **Unknown:** Should `audit` (Taste) complain about files in `context/` that are not referenced in `design.md`?
- **Impact:** Could lead to "Ghost Context."
- **Recommendation:** `audit` should verify that `design.md` explicitly references the files in `context/` (e.g., "See `context/crash.log` for details").

## 6. Implementation Roadmap
1.  **Refine `plan` Prompt:** Add "Triage Phase" to scan for loose files.
2.  **Refine `mise` Prompt:** Align "Raw Context Mode" with this `context/` folder structure.
3.  **Define "Chat Capture" Skill:** A reusable tool/instruction for agents to `write_file` immediately upon receiving long text blocks.
