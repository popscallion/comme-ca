# ENTRYPOINT (HANDOFF)

> **READ FIRST:** This file contains the critical context, recent changes, and immediate directives for the next agent or developer working on this repository.

## 1. The Situation
**Process Hardening + Research Phase.**
Two active specs: (1) Process hardening to prevent verification blind spots, (2) Research into external agent abstraction patterns (Anthropic Skills, Gemini CLI multi-agent) for potential integration.

## 2. Recent Actions
*   **Codex Support:** Implemented `@openai/codex` as a first-class citizen (scaffold, CLI wrapper, setup).
*   **Cleanup:** Removed stale references to Goose and Crush from docs and prompts.
*   **Naming Conventions:** Enforced strict naming conventions across repo.
*   **Session Reflection:** Analyzed missed `tasks.md` references → created process hardening spec.
*   **Agent Research:** Created new spec to investigate Anthropic Skills and Gemini CLI patterns.

## 3. Immediate Directives (Mission)
1.  **PRIORITY 1:** Implement `specs/feature-process-hardening/` — Add Search Hygiene and Verification rules.
2.  **PRIORITY 2:** Implement `specs/feature-bootstrap-hardening/` — Installer safety.
3.  **Maintain Hygiene:** Follow strict naming conventions.

## 4. Key Files

| File | Status | Description |
|:-----|:-------|:------------|
| `specs/feature-bootstrap-hardening/` | 🔴 P1 | Installer safety checks (chezmoi/secrets) |
| `specs/feature-openai-codex-support/` | ✅ Done | Support for @openai/codex CLI |
| `specs/feature-process-hardening/` | 🔴 P1 | Guardrails for verification and search hygiene |
| `specs/feature-agent-abstraction-research/` | 🟡 P2 | Anthropic Skills + Gemini CLI integration research |
| `AGENTS.md` | ✅ Updated | Strict naming conventions added |
| `DESIGN.md` | ✅ Created | Root-level architecture and conventions |

---
**Last Updated:** 2025-12-22 14:39  
**Previous:** Process Hardening Spec Created
