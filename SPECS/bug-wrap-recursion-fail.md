<!--
@id: bug-wrap-recursion-fail
@version: 1.0.0
@model: gemini-2.0-flash
-->

# Bug Report: Wrap Agent Recursion/Failure

## 1. The Incident
The user requested a `wrap` action. The agent:
1.  Executed `git status` (Clean).
2.  Outputted the `[HANDOFF PROMPT]` text block to the chat.
3.  **FAILED** to actually update `_ENTRYPOINT.md` with the new content.
4.  **FAILED** to commit the result.

This has happened twice in a row. The agent seems to "think" it has wrapped because it generated the text, but it didn't perform the file I/O or git operations.

## 2. Hypothesis
The `wrap` (Pass) prompt instructions might be ambiguous about *when* to stop.
*   It says: "Your final output must be a code block containing a prompt for the next agent."
*   The model might interpret this as "Generate the text and stop," skipping the `write_file` and `git commit` steps if it feels it has "completed" the intellectual part of the task.

## 3. Investigation Orders
1.  **Audit `prompts/roles/pass.md`:** Look for instructions that might imply "Output text ONLY" vs "Write to file AND Output text."
2.  **Audit `bin/cca`:** Check if the wrapper script is swallowing exit codes or output.
3.  **Recursion Check:** The user noted a "recursion fail." Is the agent getting stuck in a loop of "I need to wrap -> wrapping -> wait I need to wrap again"?

## 4. Evidence
*   Session ID: [Current Session]
*   Timestamp: 2025-12-12 18:30
*   Symptom: `[HANDOFF PROMPT]` text appears in chat, but `git log` shows no commit.

## 5. Metadata
**Priority:** High (Breaks the core handoff loop).
**Status:** Open.
