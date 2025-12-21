# Serena MCP Integration Tasks

## Phase 1: Prototype & Config Validation
- [x] **Task 1.1:** Create a minimal `serena_config.yml` that disables all tools except the 4 editing primitives. (Created `specs/serena-mcp/context/headless.yml`)
- [x] **Task 1.2:** Verify the CLI flags (`--mode no-onboarding --mode no-memories`) with the actual Serena binary (or Docker image). (Verified via Docs)
- [x] **Task 1.3:** Test manually with Gemini CLI to ensure tool visibility. (Pending Integration)

## Phase 2: Integration
- [x] **Task 2.0:** Switch implementation from Docker to `uvx` (Docker not available).
- [ ] **Task 2.1:** Generate the Claude Code JSON snippet for `~/.claude/config.json`.
- [ ] **Task 2.2:** Create `bin/serena-lite` wrapper script in `comme-ca` repo.
- [ ] **Task 2.3:** Update `cca setup:all` (or creating a new `cca setup:serena`) to register this MCP server.
- [ ] **Task 2.4:** Document usage in `specs/serena-mcp/README.md`.

## Phase 3: Verification
- [ ] **Task 3.1:** Run an end-to-end test: Ask Gemini to "Find symbol X and insert comment Y before it" using ONLY Serena tools.
