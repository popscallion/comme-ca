# Process Hardening Spec

**Status:** 🔴 Priority  
**Priority:** TOP (Systemic failure prevention)

## The Situation
A recent refactoring session revealed gaps in agent verification workflows. Specifically, a typo in a search term (`task.md` vs `tasks.md`) caused incomplete cleanup, and the lack of a final verification grep allowed the issue to go undetected until user review.

This spec addresses systemic process improvements to prevent similar failures.

## Iteration Dashboard
| Item | Status | Focus | Next Action |
|:-----|:-------|:------|:------------|
| Dual-Search Guardrail | 🟡 Active | `taste.md` | Add search hygiene directive |
| Verification Grep Rule | ⚪ Pending | `AGENTS.md` | Add to Universal Standards |
| Archive Policy Clarification | ⚪ Pending | `taste.md` | Add user confirmation step |
| Tune Directive Update | ⚪ Pending | `tune.md` | Add Search Term Hygiene |

## Key References
- `_RAW/2025-12-22-session-reflection.md` - Original analysis.
- `REQUIREMENTS.md` - Action items and success criteria.
- `DESIGN.md` - Proposed changes to role prompts.

---
**Last Updated:** 2025-12-22 14:34
