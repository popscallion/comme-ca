# Agent Handoff: comme-ca 1.1.0 Release

**Date:** 2025-11-21
**Context:** Major architectural refactor of comme-ca intelligence system

---

## Summary

This session implemented a significant architectural shift in how comme-ca roles work. Instead of projects defining custom roles (like "Maintainer" or "Initializer"), the standard roles (prep/plan/audit) now **automatically detect and adapt to project context**.

## Key Changes

### 1. Intelligent Role Adaptation
All role prompts (mise.md, menu.md, taste.md) now include:
- **Context Detection** - Scan for design.md, requirements.md, tasks.md
- **Project Type Detection** - Detect chezmoi, npm, cargo, etc. and adapt behavior
- **Compliance Assistance** - Help bring projects into comme-ca protocol compliance

### 2. Goose CLI Flag Fixes
- Changed `--instruction-file` → `--instructions` everywhere
- Changed `echo "$prompt" | goose run` → `goose run -t "$prompt"` in bin/cc
- Verified with Context7 documentation

### 3. New Features
- `cc update` subcommand - Pulls comme-ca updates and diffs AGENTS.md
- Protocol version header - `<!-- @protocol: comme-ca @version: 1.1.0 -->`
- Version drift checking in taste.md

### 4. Simplified Scaffold
The `scaffolds/high-low/AGENTS.md` went from 235 lines to 104 lines. It now focuses on:
- Quick reference table for roles
- Context detection explanation
- When to create custom roles (rarely)

## Potential Issues to Watch

### 1. Goose CLI Compatibility
We changed to use `-t` flag for text input and `--instructions` for file input. If users have older Goose versions, these flags may not work. The Context7 docs showed these are correct for current Goose.

**To verify:** `goose run --help` should show `-t` and `-i`/`--instructions` flags.

### 2. Role Prompt Complexity
The role prompts are now longer due to context detection sections. This increases token usage when running roles. Monitor if this causes issues with context limits.

### 3. Chezmoi Migration
The chezmoi repo's AGENTS.md was simplified from 306 to 90 lines. All custom role content was migrated to:
- Maintainer validation rules → requirements.md "Audit Validation Rules" section
- Initializer setup steps → design.md "Bootstrap & Setup" section

If audit/prep don't pick up these rules correctly, the migration may need adjustment.

### 4. Version Header Parsing
The protocol version header `<!-- @protocol: comme-ca @version: X.Y.Z -->` is meant to be parsed by taste.md for drift detection. This parsing logic is described in the prompt but not implemented as actual code—agents need to implement it when running.

## Files Modified

### comme-ca
- `bin/cc` - Added update subcommand, fixed goose -t flag
- `bin/install` - Fixed --instructions flag
- `README.md` - Fixed --instructions flag
- `AGENTS.md` - Fixed --instructions flag
- `prompts/roles/mise.md` - Added context detection
- `prompts/roles/menu.md` - Added context detection
- `prompts/roles/taste.md` - Added context detection + version drift check
- `scaffolds/high-low/AGENTS.md` - Simplified to new format

### chezmoi (~/.local/share/chezmoi)
- `AGENTS.md` - Simplified to 90 lines with protocol header
- `requirements.md` - Added "Audit Validation Rules" section
- `design.md` - Added "Bootstrap & Setup" section

## Testing Performed

- ✅ `cc update` in chezmoi directory - Shows diff correctly
- ✅ `cc git "show commit history"` - Goose -t flag works
- ✅ Protocol version header in scaffold
- ❓ Full `prep`/`audit` role execution not tested (would invoke Goose)

## Commits

```
comme-ca:  d34e2e9 Implement intelligent role adaptation with context detection
chezmoi:   908e5ba Migrate to comme-ca 1.1.0 with context-driven roles
```

---

## Prompt for Next Agent

```
I'm continuing work on the comme-ca intelligence system after a major refactor.

Key context:
- comme-ca 1.1.0 was just released with "intelligent role adaptation"
- Roles (prep/plan/audit) now detect project context (design.md, requirements.md) automatically
- The chezmoi dotfiles repo was migrated to this new pattern
- Goose CLI flags were fixed: --instructions for files, -t for text

Please read:
- @HANDOFF.md - Details of what changed and potential issues
- @README.md - Updated documentation
- @requirements.md - PRD for the system

If you encounter issues with roles not detecting context or Goose CLI errors,
check the HANDOFF.md "Potential Issues to Watch" section.
```

---

## Cleanup

This HANDOFF.md can be deleted once the changes are verified stable. It's meant as a temporary bridge for agent continuity.
