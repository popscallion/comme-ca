# ENTRYPOINT (HANDOFF)

> **READ FIRST:** This file contains the critical context, recent changes, and immediate directives for the next agent or developer working on this repository.

## 1. The Situation
**Process Hardening In Progress.**
A session reflection revealed verification blind spots in agent workflows. A new top-priority spec (`feature-process-hardening`) addresses systemic improvements to prevent missed references during bulk refactoring tasks.

## 2. Recent Actions
*   **Naming Conventions:** Enforced strict naming conventions (`REQUIREMENTS.md`, `DESIGN.md`, `_INBOX/`, `feature-*`, `bug-*`).
*   **Session Reflection:** Analyzed why `tasks.md` references were missed. Root cause: singular vs plural search term, no final verification grep.
*   **New Spec Created:** `specs/feature-process-hardening/` with requirements and design for guardrails.

## 3. Immediate Directives (Mission)
1.  **TOP PRIORITY:** Implement `specs/feature-process-hardening/` — Add Search Hygiene and Verification rules to role prompts.
2.  **Maintain Hygiene:** Follow new naming conventions strictly.

## 4. Key Files

| File | Status | Description |
|:-----|:-------|:------------|
| `specs/feature-process-hardening/` | 🔴 Priority | Guardrails for verification and search hygiene |
| `AGENTS.md` | ✅ Updated | Strict naming conventions added |
| `DESIGN.md` | ✅ Created | Root-level architecture and conventions |
| `prompts/roles/` | ⚪ Pending | Awaiting process hardening updates |

---
**Last Updated:** 2025-12-22 14:34  
**Previous:** Naming Conventions Refactor
