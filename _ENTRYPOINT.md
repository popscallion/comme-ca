# ENTRYPOINT (Iteration Dashboard)

## Current Status
We are in **Phase 2** (Distribution Hardening). OpenCode is now a first-class citizen.

## Active Specs
| Spec | Status | Focus |
|:-----|:-------|:------|
| `feature-agentic-abstractions` | ✅ Done | Skills/Subagents live in `prompts/` |
| `feature-openai-codex-support` | ✅ Done | `setup:codex` live in `cca` |
| `feature-opencode-integration` | ✅ Done | `COMME_CA_ENGINE=opencode` live |

## Recent Actions
*   **WRAPPER:** Updated `bin/cca` to support `opencode` as an execution engine with profile switching (`flash`/`pro`).
*   **SKILLS:** Enhanced `serena.md` with "Memory-First" Handshake protocol for shared session continuity.
*   **SCAFFOLDS:** Created `OPENCODE.md` pointer and updated `AGENTS.md` to version 1.3.0.
*   **CLEANUP:** Archived superseded research and audit specs into `specs/_ARCHIVE/`.