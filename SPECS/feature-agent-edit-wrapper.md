Goal: Implement a robust, agent-safe file editing protocol ("Case A: sd-only") in this Bun project.
Context: `sd` and `rg` are guaranteed to be present in the environment.

This involves 3 steps:
1. Creating `scripts/agent-edit.ts` (wrapper logic).
2. Updating `AGENTS.md` (mandatory protocol).
3. Updating `package.json` (script alias).

Phase 1: Create `scripts/agent-edit.ts`
Write a Bun script that accepts: `<file> <find_string> <replace_string>`
Logic flow:
1.  **File Check**: Use `await Bun.file(path).exists()` to verify presence. If missing, exit 1.
2.  **Count (Safety)**: Spawn `rg --fixed-strings --count-matches "<find_string>" <file>`.
    -   Parse output.
    -   If 0: Exit 1 (Msg: "Pattern not found. Read file content first.").
    -   If > 1: Exit 1 (Msg: "Ambiguous match ({n} found). Use more context.").
3.  **Idempotency Check**: Spawn `rg --fixed-strings --quiet "<replace_string>" <file>`.
    -   If exit code 0 (found) AND find_string count is 0: Exit 0 (Msg: "Change already applied.").
4.  **Preview**: Spawn `sd --preview --fixed-strings "<find_string>" "<replace_string>" <file>`.
    -   Pipe output to stdout so the agent sees the diff.
5.  **Apply**: Spawn `sd --fixed-strings "<find_string>" "<replace_string>" <file>`.
6.  **Verify**: Re-run `rg` check for `<replace_string>`. If found, Exit 0. Else Exit 1.

Phase 2: Update `AGENTS.md`
Under "Core Protocols", ADD a new item "4. File Editing Protocol" (do not remove others, just add/insert):

"""
4.  **File Editing Protocol (MANDATORY)**
    -   **Tooling**: NEVER use native `edit` or `replace` tools. ALWAYS use `bun agent:edit` or manual `sd` commands.
    -   **Workflow**:
        1.  **Read**: `cat <file>` (or `sed -n` ranges).
        2.  **Verify**: `bun agent:edit "<file>" "<exact_find>" "<exact_replace>"`
    -   **Semantic Edits**: For Markdown/Prose, replace FULL sentences or paragraphs to ensure uniqueness.
    -   **Ambiguity**: If `agent:edit` fails with "Ambiguous match", expand your search string to include surrounding lines.
"""

Remove the old bullet point "Read Before Write: Always read a file's current content..." since this new protocol supersedes it.

Phase 3: Scripts & aliases
1.  Update `package.json`: Add `"agent:edit": "bun scripts/agent-edit.ts"`.
2.  Ensure `scripts/agent-edit.ts` is executable (`chmod +x`).

Deliverable:
- Created `scripts/agent-edit.ts`
- Updated `AGENTS.md`
- Updated `package.json`
