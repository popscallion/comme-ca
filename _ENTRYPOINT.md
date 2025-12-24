# ENTRYPOINT (Iteration Dashboard)

## Current Status
We are in **Phase 2** (Distribution Hardening). **OpenCode** and **Codex** are now first-class citizens in the `cca` ecosystem.

## 1. Testing Instructions (Verification)

Please run the following tests to verify the new distribution features:

### Test 1: OpenCode Engine support
```bash
COMME_CA_ENGINE=opencode cca git "show status"
```
**Expected:** The `cca` wrapper should invoke `opencode run` using the `flash` profile.

### Test 2: Profile Switching
```bash
COMME_CA_PROFILE=pro cca shell "echo hello"
```
**Expected:** The wrapper should use the `pro` profile (Opus 4.5).

### Test 3: Project Scaffolding
```bash
mkdir -p /tmp/test-project && cd /tmp/test-project
cca init
```
**Expected:** The directory should contain `OPENCODE.md`, `CODEX.md`, and `AGENTS.md` (v1.3.0).

### Test 4: Serena Continuity
Read `prompts/skills/serena.md`.
**Expected:** Verify Section 1 "The Memory-First Handshake" is present.

---

## 2. Recent Actions
*   **WRAPPER:** Updated `bin/cca` to support `opencode` as an execution engine with profile switching (`flash`/`pro`).
*   **SKILLS:** Enhanced `serena.md` with "Memory-First" Handshake protocol for shared session continuity across Claude, Gemini, and OpenCode.
*   **SCAFFOLDS:** Created `OPENCODE.md` pointer and updated `AGENTS.md` to version 1.3.0.
*   **CODEX:** Stabilized Codex as a first-class citizen in tables and setup commands.
*   **CLEANUP:** Archived 4 superseded specs and the `agentic-abstractions` research into `specs/_ARCHIVE/`.

---

## 3. Active Specs
| Spec | Status | Focus |
|:-----|:-------|:------|
| `feature-mcp-redo` | 🟡 Active | Filesystem Discovery logic |
| `feature-pass` | 🟢 Active | Wrap/Pass protocol hardening |

---
**Last Updated:** 2025-12-23 23:20
**Source:** comme-ca Intelligence System
