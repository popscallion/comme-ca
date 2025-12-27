# Search Agent Implementation Checklist

- [ ] **Organization**
    - [x] Consolidate specs into `SPECS/search-agent/`
    - [x] Move raw context to `SPECS/search-agent/context/`

- [ ] **Guardrails (Lab)**
    - [ ] Create `pre-commit` hook in `comment-dit-on` to warn about unsynced prompts.

- [ ] **Implementation (Distro)**
    - [ ] Update `bin/cca` to add `search` command.
    - [ ] Implement `search_main` function (Argument parsing).
    - [ ] Implement `manage_session` function (Wrapper-Managed State).
    - [ ] Implement `construct_prompt` function (Prompt + History).
    - [ ] Implement `execute_engine` adapter (Claude/Gemini routing).

- [ ] **Configuration**
    - [ ] Update `AGENTS.md` with new `?` and `,` abbreviations.
    - [ ] Document `cca search` usage in `README.md`.

- [ ] **Verification**
    - [ ] Test Single Shot: `cca search "hello"`
    - [ ] Test Interactive: `cca search --interactive`
    - [ ] Test Resume: `cca search --resume`
