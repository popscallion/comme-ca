# Capability: Serena Editing Suite (Headless)

**You have detected the Serena MCP toolset.**
This capability upgrades your editing precision. You are now a **Surgical Editor**.

## Directive: The "LSP-First" Policy
1.  **Stop Guessing:** Do NOT use `sed`, `awk`, or regex-based replacement tools for code editing.
2.  **Stop Hallucinating:** Do NOT try to edit a file without first confirming the symbol's location.
3.  **Start Navigating:** Use `find_symbol` to locate the *exact* definition you want to modify.
4.  **Start Editing:** Use `replace_symbol_body`, `insert_after_symbol`, or `replace_content` for structurally guaranteed edits.

---

## The Toolset

### 1. Navigation & Location

#### `find_symbol`
**Purpose:** The Compass. Locates the exact file, line, and character range of a symbol (function, class, variable).
**When to use:** ALWAYS. Before editing *anything*, find it first.
**Usage:**
```javascript
// Input
{
  "name": "MyClass", 
  "kind": "class" // optional filter
}
```

#### `find_file`
**Purpose:** Fuzzy file finder. Use this if you are unsure of the exact path.
**Usage:** `find_file("Button.tsx")`

---

### 2. Surgical Insertion (Safe)

#### `insert_after_symbol` / `insert_before_symbol`
**Purpose:** Inject code *around* an existing symbol without touching the symbol itself.
**Why:** Zero risk of breaking the target symbol's internal logic. Perfect for adding logging, decorators, or sibling methods.
**Usage:**
```javascript
// Goal: Add a logging function before 'processData'
{
  "symbol_name": "processData",
  "content": "function log(msg) { console.log(msg); }\n\n"
}
```

---

### 3. Modification (Precise)

#### `replace_symbol_body`
**Purpose:** Rewrite the *entire* internals of a function/class.
**Why:** Safer than partial string replacement. You provide the *entire new body*.
**Usage:**
```javascript
// Goal: Completely rewrite 'calculateTotal'
{
  "symbol_name": "calculateTotal",
  "new_body": "{\n  return items.reduce((a, b) => a + b, 0);\n}"
}
```

#### `rename_symbol`
**Purpose:** Safe refactoring. Renames declaration AND all usages across the codebase.
**Why:** `sed` misses references; this catches them.
**Usage:**
```javascript
{
  "old_name": "userId",
  "new_name": "accountId"
}
```

#### `replace_content`
**Purpose:** The scalpel. Replaces an *exact* string match with new content.
**Critical Constraint:** The `target` string must match the file content **EXACTLY**, character-for-character, including whitespace.
**Strategy:**
1.  Read the file context first.
2.  Copy the *exact* target snippet.
3.  Apply the replacement.
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

## Error Handling
- **"Symbol not found":** Don't panic. Try `search_for_pattern` to find the text string, then use `replace_content`.
- **"Replacement target not found":** You guessed the whitespace wrong. Read the file again and copy the exact target string.
