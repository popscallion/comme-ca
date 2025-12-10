# Mise Git Scaffolding - Implementation Notes

## Implementation Status: ✅ COMPLETE

**Completed:** 2025-12-10

## What Was Implemented

### 1. Template System (`scaffolds/project-init/`)
Created template files with placeholder substitution:
- `README.template.md` - Project README with {{PROJECT_NAME}}, {{PROJECT_SLUG}}
- `LICENSE.gpl.txt` - GPL-3.0 license with {{YEAR}}, {{GIT_USER_NAME}}, {{GIT_USER_EMAIL}}
- `LICENSE.mit.txt` - MIT license alternative
- `gitignore.template` - Comprehensive .gitignore for multiple languages
- `requirements.template.md` - Starter specs template with guidance comments
- `design.template.md` - Starter design template with guidance comments

### 2. Mise Prompt Updates (`prompts/roles/mise.md`)
Extended mise.md with comprehensive git scaffolding instructions:
- **Detection Logic:** Checks for `.git/` and offers scaffolding if absent
- **Pre-Scaffolding Validation:** Validates git, gh CLI, git config, GitHub auth
- **Interactive Prompts:** Project name (required), visibility, GitHub remote, license
- **Auto-Generation:** Kebab-case slugs, directory creation, template processing
- **Scaffolding Actions:** 
  - Initialize git repository with `main` branch
  - Copy AGENTS.md and CLAUDE.md from `scaffolds/high-low/`
  - Process templates with placeholder substitution
  - Create initial commit
  - Create GitHub remote with `gh repo create`
- **Error Handling:** Atomic operations, clear error messages, cleanup on failure
- **Post-Scaffolding:** Success summary with next steps

### 3. Documentation Updates

#### README.md
- Updated directory structure to show `scaffolds/project-init/`
- Updated mise description to include "& Git Scaffolding"
- Added "Example 1: Scaffolding a New Project" workflow
- Renumbered existing examples

#### AGENTS.md
- Updated Quick Reference table: "New project scaffolding" use case
- Updated "When to Use Each Agent" for Mise with scaffolding capabilities
- Updated "What it does" to include scaffolding features
- Updated output description for new vs existing projects
- Added "Example 1: Scaffolding a Brand New Project" workflow
- Updated "Agent Permissions & Boundaries" to allow scaffolding operations
- Renumbered existing examples

## Alignment with Requirements

| Requirement | Status | Notes |
|:------------|:-------|:------|
| Detection & Activation | ✅ | Mise detects missing `.git/`, prompts documented |
| Interactive Prompts | ✅ | All prompts specified with smart defaults |
| Template System | ✅ | Templates in `scaffolds/project-init/` with placeholders |
| Scaffolding Actions | ✅ | Complete file structure documented in mise.md |
| Validation & Error Handling | ✅ | Pre-flight checks and atomic operations |
| Post-Scaffolding Actions | ✅ | Success summary and next steps documented |
| Dry-Run Mode | ⚠️ Optional | Documented as optional (runtime-dependent) |

## Implementation Approach

This implementation uses **prompt engineering** rather than code:
- Mise agent (via Goose) receives enhanced instructions in `mise.md`
- Agent interprets instructions and executes scaffolding workflow
- Templates are simple text files with `{{PLACEHOLDER}}` syntax
- Agent performs regex substitution on templates
- Agent executes git/gh commands via shell

**Rationale:** 
- Maintains comme-ca's "intelligence as configuration" philosophy
- No need to maintain executable scaffolding scripts
- Agent can adapt to edge cases using LLM reasoning
- Templates remain human-readable and easily modifiable

## Design Decisions

### 1. Two Scaffold Directories
```
scaffolds/
├── high-low/       # Agent orchestration (existing)
└── project-init/   # Git scaffolding (new)
```
**Rationale:** Semantic separation - orchestration vs. project structure templates

### 2. Opinionated Defaults
- License: GPL-3.0 (default)
- Visibility: private (default)
- GitHub remote: yes (default)
- Branch: main (always)

**Rationale:** Minimizes user input, reflects maintainer preferences, overridable

### 3. Automatic comme-ca Integration
Scaffolded projects get `AGENTS.md` + `CLAUDE.md` automatically.

**Rationale:** Eliminates need to remember `ca init`, ensures consistency

### 4. Atomic Operations
Mise instructed to stop immediately and clean up on errors.

**Rationale:** Prevents partial project states, maintains reliability

## Testing Recommendations

To validate this implementation, test the following scenarios:

### Happy Path
1. Empty directory → `prep` → Complete scaffolding with GitHub remote
2. Verify all files created with correct content
3. Verify git initialized with `main` branch
4. Verify GitHub repo created and pushed

### Edge Cases
1. Non-empty directory → Warning prompt
2. Existing `.git/` → Skip scaffolding, run validation
3. No `gh` CLI → Skip remote creation, continue with local
4. No git config → Error with fix instructions
5. GitHub auth failure → Error with `gh auth login` instruction

### Template Processing
1. Verify `{{PROJECT_NAME}}` substitution
2. Verify `{{PROJECT_SLUG}}` kebab-case transformation
3. Verify `{{YEAR}}` current year
4. Verify `{{GIT_USER_NAME}}` and `{{GIT_USER_EMAIL}}` from git config

### License Selection
1. Default GPL-3.0 → `LICENSE.gpl.txt` used
2. User selects MIT → `LICENSE.mit.txt` used
3. User selects other → Agent handles appropriately

## Future Enhancements

Potential improvements not in current scope:

1. **Language-Specific Templates**
   - `scaffolds/project-init-node/` for Node.js projects
   - `scaffolds/project-init-python/` for Python projects
   - Mise detects preferred language and offers appropriate template

2. **Custom Template Repositories**
   - Support for user-defined template locations
   - Download templates from GitHub repos

3. **Post-Scaffolding Hooks**
   - Run `npm init` or equivalent after scaffolding
   - Configure CI/CD pipelines
   - Set up pre-commit hooks

4. **Interactive License Selector**
   - Present top 5 most common licenses with descriptions
   - Link to choosealicense.com for guidance

5. **Org Selection for GitHub**
   - Detect user's GitHub orgs via `gh api user/orgs`
   - Prompt to create in personal or org account

## Migration Path

For existing comme-ca installations:

```bash
cd ~/dev/comme-ca
git pull origin main

# New template directory is automatically available
# Mise prompt updates take effect immediately for new agent sessions
```

No migration required - feature is additive and backward compatible.

## Version Compatibility

- **Requires:** Goose or equivalent agent runtime
- **Requires:** Git ≥ 2.23 (for `git branch -M`)
- **Optional:** GitHub CLI (`gh`) ≥ 2.0 for remote creation
- **Compatible with:** Fish, Zsh, Bash shells

---

**Implemented by:** Claude (Sonnet 4.5)
**Review status:** Pending user testing
**Documentation status:** Complete
