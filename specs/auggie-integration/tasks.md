# Tasks: Auggie Integration & Multi-Tool Setup

**Feature:** Multi-tool setup system with drift detection
**Status:** Crush integration complete

---

## Completed Tasks

- [x] Research Auggie CLI configuration format
- [x] Design modular setup architecture
- [x] Rename binary cc → ca
- [x] Implement setup:list command
- [x] Implement setup:auggie command
- [x] Implement setup:claude command
- [x] Implement setup:remove command
- [x] Implement drift detection with MD5 hashes
- [x] Update all documentation (cc → ca)
- [x] Reorganize specs/ to follow comme-ca pattern
- [x] Remove temporary HANDOFF.md

---

## Testing Tasks

### Phase 1: Core Functionality ✅

- [x] **Test ca setup:list** - Shows "No tools configured" initially ✓
- [x] **Test ca git pipe prompt** - Goose integration works ✓
- [x] **Test ca setup:auggie** - Generates ~/.augment/commands/*.md ✓
- [x] **Test ca drift** - Shows clean state after setup ✓

### Phase 2: Tool Configuration

- [x] **Test ca setup:claude** - Creates symlinks in ~/.claude/commands/ ✓
- [ ] **Test ca setup:remove auggie** - Verify removes generated files
- [ ] **Test drift detection** - Modify a prompt and verify drift is detected

### Phase 3: Integration

- [ ] **Test ca init** - Verify copies scaffolds to target project
- [ ] **Test prep alias** - Verify Goose runs mise.md correctly
- [ ] **Test in fresh project** - Full workflow test

---

## Future Tasks

### Immediate Next Steps

- [x] **Implement setup:crush** - Added to bin/ca following setup:auggie pattern ✓
  - Target: `~/.config/crush/commands/{prep,plan,audit}.md`
  - Format: Markdown with YAML frontmatter (like Auggie)
- [ ] **Test remaining Phase 2 items:**
  - [ ] `ca setup:remove auggie` - Verify removes generated files
  - [ ] Drift detection - Modify a prompt and verify drift is detected
- [ ] **Test Phase 3 integration:**
  - [ ] `ca init` in a fresh project
  - [ ] `prep` alias with Goose

### Crush CLI Integration

- [x] Research Crush CLI configuration format
  - Config: `~/.config/crush/crush.json`
  - Commands: `~/.config/crush/commands/` (Markdown files)
  - Data: `~/.local/share/crush/`
  - Pattern: Same as Auggie (Markdown with frontmatter likely)
- [x] Add setup:crush command to bin/ca ✓
- [x] Test Crush with comme-ca prompts ✓
- [ ] Document Crush in AGENTS.md
- [x] Update setup:list to show Crush as configurable ✓

### Enhancements

- [ ] Add ca setup:all command (configure all tools at once)
- [ ] Add ca setup:sync command (update all tools when prompts change)
- [ ] Consider prompt versioning for better drift tracking
- [ ] Clean up Goose session output in pipe prompts (currently shows session info)

---

## Notes

- Goose is the universal coordinator (no setup needed - reads prompts directly)
- Auggie index is cloud-based and NOT shareable across tools
- Drift detection uses MD5 hashes stored in ~/.comme-ca-setup/

**Last Updated:** 2025-11-23
