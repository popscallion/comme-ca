# Process Hardening Design

## Architecture Overview
This is a documentation-only change. No code is modified. The following role prompts will be updated:

```
prompts/
├── roles/
│   ├── taste.md   ← Add Search Hygiene + Archive Policy
│   └── tune.md    ← Add Search Term Hygiene check
AGENTS.md          ← Add Verification Before Completion rule
```

## Proposed Changes

### 1. `taste.md` — Search Hygiene Section (NEW)

**Location:** After "Naming Convention Check" section (~line 62)

```markdown
### Search Hygiene (Bulk Operations)
When performing "remove all X" or "replace all Y" tasks:
1. **Variations:** Search for singular AND plural forms (e.g., `task.md` AND `tasks.md`).
2. **Case Sensitivity:** Search for both lowercase and uppercase variations if applicable.
3. **Final Verification:** Run a grep after all edits and confirm zero matches in active files.
4. **Archive Prompt:** If `_ARCHIVE/` files contain the target term, ask user: "Update archived files or leave as historical records?"
```

---

### 2. `AGENTS.md` — Verification Before Completion Rule (NEW)

**Location:** Section 2 (Universal Standards), after existing rules (~line 75)

```markdown
3.  **Verification Before Completion:**
    *   Before reporting a "bulk change" task as complete (e.g., "removed all X", "renamed all Y"), run a final `grep` or `find` command.
    *   Confirm zero matches in active files (exclude `_ARCHIVE/` unless user requests otherwise).
    *   Report the raw grep output to the user for transparency.
```

---

### 3. `tune.md` — Search Term Hygiene Check (NEW)

**Location:** Section 1 (Session Analysis), add to bullet list (~line 25)

```markdown
- **Search Term Hygiene:** Did the agent search for variations (singular/plural, caps/lowercase)?
```

## Verification Plan

### Automated Tests
N/A (documentation changes only).

### Manual Verification
1. After implementation, run `grep -r "Search Hygiene" prompts/` to confirm the new section exists.
2. Run `grep -r "Verification Before Completion" AGENTS.md` to confirm the new rule exists.
3. Perform a test refactor task and verify the agent follows the new workflow.
