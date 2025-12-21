# ENTRYPOINT (HANDOFF)

> **READ FIRST:** This file contains the critical context, recent changes, and immediate directives for the next agent or developer working on this repository.

## 1. The Situation

**Phase:** Protocol Canonization & Spec Hygiene.

We have successfully integrated the **"Modular Instruction" system** for tool capabilities.
- **Serena Tools:** Now canonized as "Headless/Dumb Knife" tools via `prompts/capabilities/serena.md`.
- **Mixin Pattern:** `mise`, `menu`, and `taste` roles now dynamically load these capability instructions when they detect the tool.
- **Archive:** The old `specs/serena-mcp` has been moved to `specs/archived/`.

## 2. Iteration Dashboard

| Spec | Status | Focus | Next Action |
|:-----|:-------|:------|:------------|
| `modular-instructions` | 🟢 Completed | Canonization | Monitor Usage / Add new capabilities |
| `serena-mcp` | 🟢 Archived | Legacy | None |
| `lab-distro-sync` | 🟡 Active | Ecosystem | Audit via Codebase Discovery |

## 3. Immediate Directives (Mission)

1.  **Codebase Discovery:** Use the Codebase Discovery agent (or `cca search`) to build a mental map of the current repository structure.
2.  **Spec Audit:** Audit the `specs/` directory (specifically `specs/active/` vs `specs/archived/`).
    - Identify specifications that are effectively "Done" and move them to `archived/`.
    - Identify "Active" specs that should be promoted to canonical documentation (e.g., `lab-distro-sync`).

## 4. Key Files

- `prompts/capabilities/serena.md`: **[NEW]** The source of truth for Serena tool usage.
- `prompts/roles/*.md`: Updated to support Capability Mixins.
- `specs/`: The target of the next audit.

---
**Last Updated:** 2025-12-21
**Previous:** Architecture Sync & Tool Integration
