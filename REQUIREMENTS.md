# Requirements

## Protocol: comme-ca

**Versioning:** Use git tags and `git log` as the authority for protocol version and history.

1.  **Model Agnostic:** All roles and pipe prompts must be written in standard Markdown and executable across Claude, Gemini, Codex, and OpenCode.
2.  **Wrapper Centric:** The `cca` binary is the authoritative bridge. Manual invocation of underlying engines is discouraged.
3.  **Protocol Sync (Shim):** New projects MUST use the Shim pattern (`@import`) in `AGENTS.md` to reference the canonical Protocol Registry. Manual duplication of core rules is forbidden.
4.  **Discovery First (Epistemic Rigor):**
    *   **List Before Read:** NEVER assume file paths. Always use `ls` (or equivalent discovery tools) to verify directory contents before attempting to read or move files.
    *   **Bleeding Edge Protocol:** When documentation is stale or absent, agents MUST use CLI introspection (`--help`, error logs) as the source of truth.
5.  **Unit of Work:** All changes must be encapsulated in a Spec (`SPECS/feature-*` or `SPECS/bug-*`).
6.  **Inbox First:** `_INBOX/` MUST be checked at the start of every session. If non‑empty, contents MUST be triaged before other work proceeds.
7.  **Raw Intake Format:** Raw text is appended to `SPECS/<spec>/_RAW/RAW.md` with a `YYYY-MM-DD` heading when possible. Missing date stamps must not block the workflow.
8.  **Non‑Text Intake:** Non‑text artifacts go in `SPECS/<spec>/_RAW/assets/` and are referenced from `RAW.md`.
9.  **Completion & Archiving (Specs are Ephemeral):**
    1.  **Synthesize:** Update `DOCS/` or root docs with the finalized, single‑source truth.
    2.  **Archive Chat:** Concatenate `RAW.md` into `SPECS/_ARCHIVE/chat-<spec-slug>.md`.
    3.  **Prune:** Remove the completed spec directory from `SPECS/` (no enclosing archive folder).
    4.  **Assets:** Non‑text artifacts may be deleted after completion; rely on git history for retrieval.
    *   **Legacy:** Pre‑existing archived folders in `SPECS/_ARCHIVE/` may remain unless explicitly requested to reorganize.
10. **Clean Handoff:** Sessions must be closed with the `pass` (wrap) role to update the `_ENTRYPOINT.md` status.
11. **Documentation:** Root-level documentation must stay in sync with implementation. Aliases (e.g., `prep`, `plan`) must wrap the `cca` command for the active engine.
12. **Separation of Concerns:** `comme-ca` defines the behavior (DNA); `comme-ci` defines the system state (Governor).
13. **Sibling Repository Constraints:** When modifying sibling repositories (e.g., `comme-ca` from `comme-ci`), agents MUST use atomic `write_file` operations instead of `replace_content` to avoid sandbox path violation errors.
