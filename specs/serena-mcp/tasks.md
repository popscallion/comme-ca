# Serena MCP Integration Tasks

## Phase 1: Prototype & Config Validation
- [ ] **Task 1.1:** Create a minimal `serena_config.yml` that disables all tools except the 4 editing primitives.
- [ ] **Task 1.2:** Verify the CLI flags (`--mode no-onboarding --mode no-memories`) with the actual Serena binary (or Docker image).
- [ ] **Task 1.3:** Test manually with Gemini CLI to ensure tool visibility.

## Phase 2: Integration
- [ ] **Task 2.1:** Create `bin/serena-lite` wrapper script in `comme-ca` repo.
- [ ] **Task 2.2:** Update `cca setup:all` (or creating a new `cca setup:serena`) to register this MCP server.
- [ ] **Task 2.3:** Document usage in `specs/serena-mcp/README.md` (or update root `README.md` if it becomes a core tool).

## Phase 3: Verification
- [ ] **Task 3.1:** Run an end-to-end test: Ask Gemini to "Find symbol X and insert comment Y before it" using ONLY Serena tools.
