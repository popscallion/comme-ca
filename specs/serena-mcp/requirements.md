# Serena MCP Integration Requirements

## 1. Overview
Integrate **Serena MCP** as a specialized "Precision Editing" tool for the `comme-ca` ecosystem, specifically tailored for use with Gemini CLI and Claude Code. The integration must bypass Serena's opinionated features (onboarding, memories) and expose *only* its LSP-powered editing primitives.

## 2. User Stories
- **As a** developer using Gemini CLI / Claude Code,
- **I want** to use Serena's robust `find_symbol`, `insert_before`, `insert_after`, and `replace_content` tools,
- **So that** I can perform precise, symbol-aware code edits without relying on fuzzy LLM line matching.

- **As a** system architect,
- **I want** to disable Serena's "Project Memories" and "Onboarding" workflows,
- **So that** the tool acts as a stateless, fast utility rather than a heavy, opinionated agent.

- **As a** user,
- **I want** a simple configuration (e.g., `serena_config.yml` or CLI flags) that works consistently across different environments (local, cloud, Docker),
- **So that** I can deploy this capability easily.

## 3. Functional Requirements
1.  **Tool Whitelist:** The system SHALL explicitly enable ONLY the following Serena tools:
    -   `find_symbol` (or equivalent name found in docs)
    -   `insert_before_symbol` / `insert_before`
    -   `insert_after_symbol` / `insert_after`
    -   `replace_content`
2.  **Feature suppression:** The system SHALL explicitly DISABLE:
    -   Onboarding wizards (`no-onboarding` mode)
    -   Memory management (`no-memories` mode)
    -   Refactoring pipelines not requested
    -   Linting/Formatting (unless explicitly requested later)
3.  **Interface:** The integration MUST be callable via the standard MCP protocol compatible with Gemini CLI and Claude Code.
4.  **Deployment:** The solution SHOULD support a Docker-based deployment to ensure environment consistency.

## 4. Non-Functional Requirements
- **Latency:** Tool startup time should be minimized (avoiding indexing steps).
- **Portability:** Configuration must be portable (dotfiles-friendly).

## 5. Constraints
- Must use the "2025" era modular features of Serena (Modes: `no-onboarding`, `no-memories`).
- Must not require interactive steps during initialization.
