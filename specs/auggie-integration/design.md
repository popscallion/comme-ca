# CLI Tool Integration Specification
**comme-ca Intelligence System**

## Overview

This document defines how comme-ca integrates with multiple AI CLI tools while keeping Goose as the primary coordinator. The architecture prioritizes simplicity over abstraction—adding or removing tools should be trivial.

---

## 1. Architecture: Goose as Universal Coordinator

```
┌─────────────────────────────────────────────────┐
│           Goose (Primary Runtime)               │
│   - Reads prompts directly from comme-ca        │
│   - Full agent capabilities                     │
│   - No configuration generation needed          │
└────────────────┬────────────────────────────────┘
                 │
    ┌────────────┼────────────┐
    ▼            ▼            ▼
  prep         plan        audit
(mise.md)   (menu.md)   (taste.md)
                 │
                 ▼
┌─────────────────────────────────────────────────┐
│        Optional Tool Integrations               │
│   auggie, claude, crush (future)                │
│   Configured via: ca setup:<tool>               │
└─────────────────────────────────────────────────┘
```

### Design Principles

1. **Goose is always available** - No setup required, reads prompts directly
2. **Optional tools are opt-in** - Configure only what you use
3. **Easy to add/remove** - Single command per tool
4. **Drift detection** - Know when configs need updating

---

## 2. Binary Rename: `cc` → `ca`

### Rationale
The original name `cc` shadows the C compiler (`/usr/bin/cc` → Clang) on Unix systems, causing build conflicts when `~/dev/comme-ca/bin` is in PATH.

### Status
- [x] Renamed `bin/cc` → `bin/ca`
- [ ] Update README.md references
- [ ] Update AGENTS.md references
- [ ] Update scaffolds/high-low/AGENTS.md
- [ ] Update chezmoi install script

---

## 3. Tool Setup Commands

### Available Commands

```bash
# List all tools and their status
ca setup:list

# Configure specific tools
ca setup:auggie              # Augment Code CLI
ca setup:claude              # Claude Code
ca setup:crush               # Charm Crush (future)

# Remove tool configuration
ca setup:remove auggie
ca setup:remove claude

# Check for drift
ca drift
```

### What Each Setup Does

| Tool | Action | Location |
|:-----|:-------|:---------|
| **auggie** | Generates commands with Auggie frontmatter | `~/.augment/commands/` |
| **claude** | Creates symlinks to comme-ca prompts | `~/.claude/commands/` |
| **crush** | TBD | `~/.config/crush/` |

### Adding a New Tool

To add support for a new CLI tool (e.g., Crush):

1. Add detection in `setup_list()`
2. Add `setup_crush()` function
3. Add case in `setup_remove()`
4. Add drift check in `drift()`

Estimated time: 15-30 minutes per tool.

---

## 4. Drift Detection

### How It Works

When you run `ca setup:<tool>`, it stores metadata:

```bash
# ~/.augment/.comme-ca-setup
setup_date=2025-11-23T12:00:00Z
comme_ca_commit=abc123...
mise_hash=def456...
menu_hash=ghi789...
taste_hash=jkl012...
```

Running `ca drift` compares current prompt hashes against stored hashes.

### Example Output

```
$ ca drift
Checking for prompt drift...
─────────────────────────────────────────────

Auggie CLI:
  ⚠ Drift detected - run: ca setup:auggie

Claude Code:
  ✓ Up to date

Comme-ca repository:
  ⚠ Updates available - run: cd ~/dev/comme-ca && git pull

─────────────────────────────────────────────
Action required: Update drifted configurations
```

### Maintenance Workflow

```bash
# Weekly check (or add to cron)
ca drift

# If drift detected:
git -C ~/dev/comme-ca pull    # Get latest prompts
ca setup:auggie               # Regenerate Auggie configs
ca setup:claude               # Claude uses symlinks, rarely needs update

# Verify
ca drift                      # Should show all green
```

---

## 5. Tool-Specific Details

### Goose (Primary)

**No setup required.** Goose reads prompts directly via `--instructions` flag.

```bash
# Aliases (add to shell config)
alias prep="goose run --instructions ~/dev/comme-ca/prompts/roles/mise.md"
alias plan="goose run --instructions ~/dev/comme-ca/prompts/roles/menu.md"
alias audit="goose run --instructions ~/dev/comme-ca/prompts/roles/taste.md"
```

**Why Goose is primary:**
- Most flexible (works with any markdown prompt)
- No transformation needed
- Full agent capabilities
- Best for automation/CI

### Auggie CLI

**Setup:** `ca setup:auggie`

**What it creates:**
- `~/.augment/commands/prep.md` - With Auggie frontmatter
- `~/.augment/commands/plan.md`
- `~/.augment/commands/audit.md`
- `~/.augment/rules/orchestration.md` - Always-applied context
- `~/.augment/.comme-ca-setup` - Drift detection metadata

**Usage:**
```bash
auggie
> /prep
> /plan
> /audit
```

**Unique features:**
- Cloud-based codebase indexing
- Memories system
- Subagents

### Claude Code

**Setup:** `ca setup:claude`

**What it creates:**
- `~/.claude/commands/prep.md` → symlink to mise.md
- `~/.claude/commands/plan.md` → symlink to menu.md
- `~/.claude/commands/audit.md` → symlink to taste.md
- `~/.claude/.comme-ca-setup` - Drift detection metadata

**Usage:**
```bash
claude
> /prep
> /plan
> /audit
```

**Note:** Claude Code also reads project-level AGENTS.md and CLAUDE.md automatically.

### Crush (Future)

**Status:** Not yet implemented

**Charm Crush** (https://github.com/charmbracelet/crush) is Charm's AI CLI tool.

**Planned setup:** `ca setup:crush`

**Research needed:**
- [ ] Configuration file format
- [ ] System prompt mechanism
- [ ] Command/alias system

---

## 6. Fresh System Setup

### Automated (via chezmoi)

When `chezmoi apply` runs on a fresh system:

1. Clones comme-ca to `~/dev/comme-ca`
2. Makes `bin/ca` executable
3. Optionally runs `ca setup:*` for configured tools

### Manual Setup

```bash
# 1. Clone comme-ca
git clone git@github.com:popscallion/comme-ca ~/dev/comme-ca

# 2. Add to PATH (in shell config)
export PATH="$HOME/dev/comme-ca/bin:$PATH"

# 3. Add Goose aliases (always)
alias prep="goose run --instructions ~/dev/comme-ca/prompts/roles/mise.md"
alias plan="goose run --instructions ~/dev/comme-ca/prompts/roles/menu.md"
alias audit="goose run --instructions ~/dev/comme-ca/prompts/roles/taste.md"

# 4. Optional: Configure other tools
ca setup:auggie    # If using Auggie
ca setup:claude    # If using Claude Code

# 5. Verify
ca setup:list
```

---

## 7. Cross-Tool Usage Patterns

### When to Use Each Tool

| Scenario | Recommended Tool |
|:---------|:-----------------|
| Complex automation, CI/CD | Goose |
| Quick CLI translation | `ca git "..."` (via Goose) |
| Deep codebase queries | Auggie (has indexing) |
| IDE-integrated work | Claude Code |
| Interactive terminal | Goose or Auggie |

### Example Workflows

**Feature Development:**
```bash
# 1. Bootstrap environment
prep                    # Goose runs mise.md

# 2. Plan the feature
plan                    # Goose runs menu.md

# 3. Implement (manual or other agents)

# 4. Audit before release
audit                   # Goose runs taste.md
```

**Quick Command:**
```bash
ca git "undo last commit but keep changes"
# → git reset --soft HEAD~1
```

**Using Auggie for Its Indexing:**
```bash
auggie "What functions call the authentication service?"
# Auggie's index makes this fast
```

---

## 8. Codebase Scanning & Documentation Updates

### Files to Update for cc → ca Rename

```bash
# Find all references
grep -r "bin/cc\|'cc '\|\"cc \"|alias cc=" ~/dev/comme-ca

# Files to update:
README.md
AGENTS.md
scaffolds/high-low/AGENTS.md
requirements.md
prompts/roles/*.md (if they reference cc)
```

### Chezmoi Integration

Update `~/.local/share/chezmoi/run_once_install_comme_ca.sh.tmpl`:

```bash
# Change this line:
chmod +x "${COMME_CA_DIR}/bin/cc"

# To:
chmod +x "${COMME_CA_DIR}/bin/ca"
```

---

## 9. Implementation Status

### Completed
- [x] Renamed `bin/cc` → `bin/ca`
- [x] Added `ca setup:list` command
- [x] Added `ca setup:auggie` command
- [x] Added `ca setup:claude` command
- [x] Added `ca setup:remove` command
- [x] Added `ca drift` command
- [x] Drift detection via hash comparison

### Pending
- [ ] Update README.md (cc → ca)
- [ ] Update AGENTS.md (cc → ca)
- [ ] Update scaffolds/high-low/AGENTS.md
- [ ] Update requirements.md
- [ ] Update chezmoi install script
- [ ] Add `ca setup:crush` (when Crush docs available)
- [ ] Add shell completion for `ca` commands

---

## 10. Why This Approach?

### Rejected: Full Adapter System
We considered a generalized adapter pattern with:
- `adapters/` directory
- Common utilities
- YAML frontmatter parsing
- Automated sync

**Why rejected:** Overkill for 3 tools and 3 prompts. Would add ~300 lines of infrastructure for a problem we don't have yet.

### Chosen: Simple Setup Commands
- ~200 lines in `bin/ca`
- Direct, readable code
- Easy to add/remove tools
- No abstractions to maintain

**Trade-off:** If we later need 10+ tools with constantly changing prompts, we'll revisit the adapter pattern. YAGNI for now.

---

## References

- [Auggie CLI Docs](https://docs.augmentcode.com/cli/overview)
- [Charm Crush](https://github.com/charmbracelet/crush)
- [dot-ai](https://github.com/luisrudge/dot-ai) - Similar multi-tool config generator

---

**Version:** 1.0.0
**Created:** 2025-11-23
**Status:** Implemented
