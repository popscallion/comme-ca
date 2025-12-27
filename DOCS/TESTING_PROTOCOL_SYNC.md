# Protocol Sync & Agentic Abstractions: Testing Guide

This guide outlines how to verify the new **Protocol Synchronization** and **Agentic Abstraction** features in `comme-ca` v1.4.0.

## 1. Prerequisites
Ensure you have the latest `cca` binary and protocol registry installed.

```bash
# Update local binary and registry
cd ~/dev/comme-ca
cca setup:sync
```

## 2. Test Cases

### Case A: New Project Scaffolding (The Shim)
**Goal:** Verify new projects use the "Shim" pattern for `AGENTS.md`.

1.  Create a fresh directory: `mkdir ~/tmp/test-shim && cd ~/tmp/test-shim`
2.  Run `prep` (Mise).
3.  **Verify:**
    *   `AGENTS.md` should be small (< 20 lines).
    *   It should contain `<!-- @import: ~/.comme-ca/protocol/dev/AGENTS.core.md -->`.
    *   `SPECS/REQUIREMENTS.md` and `SPECS/DESIGN.md` should NOT exist (should be at root).
    *   `REQUIREMENTS.md` and `DESIGN.md` should be at the root.
    *   `SPECS/`, `DOCS/`, and `_INBOX/` should exist.

### Case B: Protocol Maintenance (Mise)
**Goal:** Verify `mise` detects outdated protocols.

1.  In `~/tmp/test-shim`, edit `AGENTS.md`.
2.  Change the header to `<!-- @protocol: comme-ca @version: v0.0.1 -->`.
3.  Run `prep`.
4.  **Verify:** Mise should report: "Protocol update available (v0.0.1 -> dev). Run `cca setup:sync`?"

### Case C: Protocol Harvesting (Tune)
**Goal:** Verify `tune` creates feedback artifacts.

1.  Run `tune` in any project.
2.  Instruction: "We ignored the standard naming convention and used snake_case for specs because it was faster."
3.  **Verify:** `tune` should generate `_INBOX/protocol-feedback-naming.md` with the observation and proposal.

### Case D: Subagent Abstraction
**Goal:** Verify the `code-reviewer` subagent exists and follows the contract.

1.  Run `cca search "Check prompts/subagents/code-reviewer.md"`.
2.  **Verify:** The file exists and contains the `**Role:**` and `**Goal:**` headers.

## 3. Rollout Checklist
- [ ] Push `main` to origin.
- [ ] Run `cca setup:sync` on all development machines.
- [ ] Announce v1.4.0 in `_ENTRYPOINT.md` of active projects.
