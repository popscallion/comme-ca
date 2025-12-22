<!--
@title: Serena Coding Skill
@desc: Surgical editing procedures using LSP tools.
-->
# SKILL: Serena Surgical Editor

**This is a SKILL.** It defines a procedure you must follow when editing code.

## The "LSP-First" Policy
1.  **Stop Guessing:** Do NOT use `sed`, `awk`, or regex-based replacement tools for code editing.
2.  **Stop Hallucinating:** Do NOT try to edit a file without first confirming the symbol's location.
3.  **Start Navigating:** Use `find_symbol` to locate the *exact* definition you want to modify.
4.  **Start Editing:** Use `replace_symbol_body`, `insert_after_symbol`, or `replace_content` for structurally guaranteed edits.

---

## The Toolset (How to use the Tools)

### 1. Navigation & Location

#### `find_symbol`
**Purpose:** The Compass. Locates the exact file, line, and character range of a symbol.
**Usage:** `find_symbol({ "name": "MyClass", "kind": "class" })`

#### `find_file`
**Purpose:** Fuzzy file finder. Use this if you are unsure of the exact path.
**Usage:** `find_file("Button.tsx")`

---

### 2. Surgical Insertion (Safe)

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

### 3. Modification (Precise)

#### `replace_symbol_body`
**Purpose:** Rewrite the *entire* internals of a function/class.
**Usage:**
```javascript
{
  "symbol_name": "calculateTotal",
  "new_body": "{\n  return items.reduce((a, b) => a + b, 0);\n}"
}
```

#### `replace_content`
**Purpose:** The scalpel. Replaces an *exact* string match with new content.
**Usage:**
```javascript
{
  "path": "/src/config.ts",
  "target": "const MAX_RETRIES = 3;",
  "replacement": "const MAX_RETRIES = 5;"
}
```

---

## Workflow: The "Locate-Verify-Edit" Loop

**Wrong (Lazy):**
> "I'll just try to rewrite `src/utils.py` assuming I know the lines."

**Right (Serena):**
1.  **Locate:** `find_symbol("validate_email")` → Finds it in `src/validators/email.py`.
2.  **Verify:** (Optional) `read_file` to check the context if `find_symbol` was ambiguous.
3.  **Edit:** `replace_symbol_body("validate_email", "{ ... new code ... }")`.