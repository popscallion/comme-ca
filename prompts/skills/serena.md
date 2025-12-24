<!--
@title: Serena Coding Skill
@desc: Surgical editing procedures and shared memory continuity.
-->
# SKILL: Serena Surgical Editor & Memory

**This is a SKILL.** It defines a procedure you must follow when editing code and maintaining session continuity.

## 1. The "Memory-First" Handshake
Before performing any task, you MUST establish context by reading the shared brain.
1.  **List:** `list_memories()` to see what context is available.
2.  **Read:** `read_memory("active_context")` (or the most relevant memory) to understand the current project state, recent changes, and next steps.
3.  **Sync:** At the end of a session, or after a major milestone, `write_memory("active_context", "...")` to record your progress for the next agent.

## 2. The "LSP-First" Editing Policy
1.  **Stop Guessing:** Do NOT use `sed`, `awk`, or regex-based replacement tools for code editing.
2.  **Stop Hallucinating:** Do NOT try to edit a file without first confirming the symbol's location.
3.  **Start Navigating:** Use `find_symbol` to locate the *exact* definition you want to modify.
4.  **Start Editing:** Use `replace_symbol_body`, `insert_after_symbol`, or `replace_content` for structurally guaranteed edits.

---

## The Toolset (How to use the Tools)

### A. Navigation & Location

#### `find_symbol`
**Purpose:** The Compass. Locates the exact file, line, and character range of a symbol.
**Usage:** `find_symbol({ "name": "MyClass", "kind": "class" })`

#### `find_file`
**Purpose:** Fuzzy file finder. Use this if you are unsure of the exact path.
**Usage:** `find_file("Button.tsx")`

---

### B. Surgical Insertion (Safe)

#### `insert_after_symbol`
**Purpose:** Inject code *around* an existing symbol without touching the symbol itself.
**Usage:**
```javascript
{
  "symbol_name": "processData",
  "content": "function log(msg) { console.log(msg); }\n\n"
}
```

---

### C. Modification (Precise)

#### `replace_symbol_body`
**Purpose:** Rewrite the *entire* internals of a function/class.
**Usage:**
```javascript
{
  "symbol_name": "calculateTotal",
  "new_body": "{\n  return items.reduce((a, b) => a + b, 0);
}"
}
```

---

### D. Continuity & Context

#### `read_memory` / `write_memory`
**Purpose:** Shared state across different AI engines (Claude, Gemini, Codex, OpenCode).
**Policy:** Always prefer `active_context` for high-level status.

---

## Workflow: The "Locate-Verify-Edit" Loop

1.  **Handshake:** Read memory.
2.  **Locate:** `find_symbol("validate_email")` → Finds it in `src/validators/email.py`.
3.  **Verify:** (Optional) `read_file` to check context.
4.  **Edit:** `replace_symbol_body("validate_email", "{ ... new code ... }")`.
5.  **Handoff:** Write memory.
