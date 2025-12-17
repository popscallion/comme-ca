# ENTRYPOINT (HANDOFF)

> **READ FIRST:** This file contains the critical context, recent changes, and immediate directives for the next agent or developer working on this repository.

## 1. The Situation

We are in the **Ecosystem Governance** phase.

**Strategic Context:** This repository (`comme-ca`) is the **Distro** (Public Tooling) in a three-tier ecosystem:
- **Lab** (`comment-dit-on`) → creates prompts
- **Distro** (`comme-ca`) → stabilizes and distributes
- **comme-ci** (chezmoi) → consumes and **governs** the ecosystem

The governance relationship is now formalized: comme-ci contains symlinks to Lab and Distro in its `ecosystem/` directory and runs cross-repository audits.

## 2. Recent Actions

*   **Ecosystem Audit:** Comprehensive audit performed across all four original systems (now three-tier triad).
*   **Taste v1.1.0:** Added "Ecosystem Audit Mode" (Section 7) to `prompts/roles/taste.md` with detection-based cross-repo validation and guardrails.
*   **Governance Docs:** Updated `docs/SYNC_STRATEGY.md` with formal topology.
*   **Shell Portability:** Added directive #4 to `AGENTS.md` and updated `prompts/roles/mise.md`.

## 3. Next Orders

1.  **Commit:** Stage and commit the taste.md v1.1.0 changes (ecosystem audit section).
2.  **Lab Sync:** Coordinate with Lab (`comment-dit-on`) to rename `AGENTS.md` → `SEARCH_AGENT_GUIDE.md` (semantic collision fix).
3.  **Search Agent:** Review `specs/search-agent-recommendation.md` for `cca search` implementation.
4.  **Flow Audit:** Execute verification tests in `specs/flow-audit/flow-audit.md`.

## 4. Key References

*   `@docs/SYNC_STRATEGY.md` - The Ecosystem Architecture (Lab → Distro → Consumer).
*   `@prompts/roles/taste.md` - Now includes ecosystem governance (v1.1.0).
*   `@prompts/roles/pass.md` - Wrap protocol (fix verified).

## 5. Cross-Repository Notes

| Repo | Relationship | Notes |
|:-----|:-------------|:------|
| `comment-dit-on` | Upstream (Lab) | AGENTS.md semantic collision needs resolution |
| `comme-ci` | Downstream (Governor) | Contains `ecosystem/distro/` symlink to this repo |
| `larval-incubator` | Consumer | Not a governed pillar; uses `cca` tools |

---
**Last Updated:** 2025-12-17
**Phase:** Ecosystem Governance & Cross-Repo Alignment
