<!--
@id: toolset-analysis
@version: 1.0.0
@model: gemini-2.0-flash
-->

# comme-ca Toolset Analysis

**Date:** 2025-12-22
**Scope:** Repository analysis of `comme-ca` ecosystem.

## Executive Summary

`comme-ca` is a recursive intelligence system designed to orchestrate AI agents (Claude Code, Gemini CLI, Goose) through standardized roles and context management. It acts as a "operating system" for AI-assisted development, decoupling intelligence (prompts) from infrastructure.

## Supported Ecosystem

### Primary Engines
1.  **Claude Code (`claude`)**
    *   **Status:** First-class citizen. Default engine for the `cca` CLI.
    *   **Integration:** `cca setup:claude` configures `~/.claude/commands` with symlinks to roles.
    *   **Usage:** Handles "Pipe" commands (`cca git ...`) and interactive roles.

2.  **Gemini CLI (`gemini`)**
    *   **Status:** First-class citizen.
    *   **Integration:** `cca setup:gemini` generates TOML configuration files in `~/.gemini/commands` wrapping the role prompts.
    *   **Context:** Reads `GEMINI.md` (which pointers to `AGENTS.md`) for project-specific context.

3.  **Goose**
    *   **Status:** Supported via configuration.
    *   **Integration:** Referenced in `README.md` as a valid `COMME_CA_ENGINE`.
    *   **Usage:** Can run roles directly (e.g., `goose run --instructions ...`).

### Integrations
*   **Raycast:** The `prompts/pipe/` directory contains prompts compatible with Raycast Script Commands. The `cca` binary includes a "Raycast Shim" to handle argument placeholders (e.g., `{argument}`, `{selection}`).
*   **Antigravity:** Referenced in Gemini configuration, implying integration with a browser automation or allowlist system.
*   **Chezmoi:** Explicitly supported in the `Mise` (`prep`) role for dotfiles management.

## Architecture

### 1. The "Holon" Structure
The system is recursive. It uses itself to build itself.
*   **Prompts (`prompts/`)**: The source code of intelligence.
*   **Scaffolds (`scaffolds/`)**: Templates for propagating the system to new projects.
*   **CLI (`bin/cca`)**: The glue layer bridging the shell and the AI engine.

### 2. Standard Roles (The "Kitchen" Metaphor)
Roles are standardized personas that perform specific parts of the software lifecycle:

| Role | Alias | Function |
|:-----|:------|:---------|
| **Mise** | `prep` | System setup, git scaffolding, dependency validation. |
| **Menu** | `plan` | Architecture, requirements gathering, spec generation. |
| **Taste** | `audit` | QA, drift detection, compliance checking. |
| **Tune** | `retro` | Process analysis and optimization. |
| **Pass** | `wrap` | Handoff, context consolidation, session closure. |

### 3. Context Management
The system relies on a rigid file structure to ground agents:
*   `_ENTRYPOINT.md`: The "Iteration Dashboard" (mutable state).
*   `AGENTS.md`: The central router and ruleset (immutable during session).
*   `specs/`: Feature-driven development context (`REQUIREMENTS.md`, `DESIGN.md`).

### 4. Capabilities
*   **Search Agent:** A sophisticated retrieval system using "Haiku 4.5" (Smart) or "Cerebras 120b" (Fast). It implements a "Triage First" logic, effectively acting as a Level 1 support agent before invoking external tools.
*   **Serena:** A "headless" capability suite focused on "Surgical Editing". It enforces an "LSP-First" policy, requiring agents to `find_symbol` before modifying code, rejecting unsafe regex/line-based edits.

## Tooling Standards

*   **Discovery First:** Agents are strictly forbidden from guessing file paths. They must list/find before reading.
*   **Non-Interactive:** All tools must support non-interactive modes (`CI=true`).
*   **Universal Metadata:** All generated markdown must include `@id`, `@version`, and `@model` headers.
