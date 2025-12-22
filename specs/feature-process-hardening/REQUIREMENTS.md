# Process Hardening Requirements

## Overview
Implement guardrails in `comme-ca` agent prompts to prevent verification blind spots and incomplete cleanup tasks.

## User Stories
- As an agent, I want clear guidelines on search term variations so that I don't miss plural/singular references.
- As a user, I want verification steps to be mandatory so that incomplete refactors are caught before I review.
- As a user, I want explicit confirmation before archived files are excluded from updates.

## Functional Requirements

### REQ-1: Dual-Search Guardrail
The `taste.md` (audit) role SHALL include a directive requiring agents to search for common variations of a term (singular/plural, caps/lowercase) when performing "remove all X" tasks.

**Acceptance Criteria:**
- `taste.md` contains a "Search Hygiene" section.
- The section explicitly lists: "Search for both `foo` and `foos` when removing references."

### REQ-2: Verification Grep Mandate
The `AGENTS.md` Universal Standards SHALL include a rule requiring a final verification grep before declaring any "remove all X" or "replace all Y" task complete.

**Acceptance Criteria:**
- `AGENTS.md` section 2 includes a "Verification Before Completion" rule.
- The rule states: "Before reporting completion of a bulk change, run a final grep and confirm zero matches in active files."

### REQ-3: Archive Policy Clarification
The `taste.md` role SHALL prompt the user to confirm whether `_ARCHIVE/` files should be updated or left as historical records.

**Acceptance Criteria:**
- `taste.md` contains an explicit check: "If `_ARCHIVE/` files contain the target term, ask user: 'Update archived files or leave as-is?'"

### REQ-4: Tune Search Hygiene Directive
The `tune.md` role SHALL include a reminder to check for search term variations during session analysis.

**Acceptance Criteria:**
- `tune.md` Section 1 (Session Analysis) includes: "Check if search terms used variations (singular/plural)."

## Success Metrics
- Zero missed references in future bulk refactoring tasks.
- User no longer needs to manually grep for stale terms.

## Out of Scope
- Automated testing of prompts (future work).
- CI/CD integration for prompt validation.
