# Requirements

## Protocol: comme-ca v1.3.0

1.  **Model Agnostic:** All roles and pipe prompts must be written in standard Markdown and executable across Claude, Gemini, Codex, and OpenCode.
2.  **Wrapper Centric:** The `cca` binary is the authoritative bridge. Manual invocation of underlying engines is discouraged.
3.  **Discovery First (Epistemic Rigor):**
    *   **List Before Read:** NEVER assume file paths. Always use `ls` (or equivalent discovery tools) to verify directory contents before attempting to read or move files.
    *   **Bleeding Edge Protocol:** When documentation is stale or absent, agents MUST use CLI introspection (`--help`, error logs) as the source of truth.
4.  **Unit of Work:** All changes must be encapsulated in a Spec (`specs/feature-*` or `specs/bug-*`).
5.  **Atomic Archiving:** Archiving specifications requires a three-step protocol:
    1.  **Flag:** Rename directory to `SUPERSEDED-feature-*`.
    2.  **Note:** Add a `SUPERSESSION_NOTICE.md` or header explaining why.
    3.  **Move:** Move the folder to `specs/_ARCHIVE/`.
6.  **Clean Handoff:** Sessions must be closed with the `pass` (wrap) role to update the `_ENTRYPOINT.md` status.
7.  **Documentation:** Root-level documentation must stay in sync with implementation. Aliases (e.g., `prep`, `plan`) must wrap the `cca` command for the active engine.
8.  **Separation of Concerns:** `comme-ca` defines the behavior (DNA); `comme-ci` defines the system state (Governor).
9.  **Sibling Repository Constraints:** When modifying sibling repositories (e.g., `comme-ca` from `comme-ci`), agents MUST use atomic `write_file` operations instead of `replace_content` to avoid sandbox path violation errors.
