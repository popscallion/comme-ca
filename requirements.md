# Requirements

## Protocol: comme-ca v1.3.0

1.  **Model Agnostic:** All roles and pipe prompts must be written in standard Markdown and executable across Claude, Gemini, Codex, and OpenCode.
2.  **Wrapper Centric:** The `cca` binary is the authoritative bridge. Manual invocation of underlying engines is discouraged.
3.  **Discovery First:** Agents must prioritize reading `AGENTS.md`, `DESIGN.md`, and `REQUIREMENTS.md` before taking action.
4.  **Unit of Work:** All changes must be encapsulated in a Spec (`specs/feature-*` or `specs/bug-*`).
5.  **Clean Handoff:** Sessions must be closed with the `pass` (wrap) role to update the `_ENTRYPOINT.md` status.
6.  **Documentation:** Root-level documentation must stay in sync with implementation. Aliases (e.g., `prep`, `plan`) must wrap the `cca` command for the active engine.
7.  **Separation of Concerns:** `comme-ca` defines the behavior (DNA); `comme-ci` defines the system state (Governor).