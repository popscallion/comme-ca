# Mise Git Scaffolding Extension - Requirements

## Overview
Extend the Mise (prep) agent to detect uninitialized repositories and offer interactive git scaffolding with GitHub integration. This transforms Mise from purely validating existing environments to also bootstrapping new projects.

## User Stories
- As a developer starting a new project, I want Mise to detect the lack of git initialization and offer to scaffold a complete repository structure so I can start coding immediately.
- As a developer, I want smart defaults with minimal prompts so I can quickly initialize a standard project without answering 20 questions.
- As a developer, I want to preview what will be created (dry-run) before committing to scaffolding.
- As a developer, I want my new repos to automatically include comme-ca agent orchestration so I don't have to remember to run `ca init` separately.

## Functional Requirements

### 1. Detection & Activation
1. Mise SHALL detect if the current directory lacks a `.git/` directory
2. Mise SHALL offer to scaffold a new repository when `.git/` is absent
3. Mise SHALL support an explicit `--new` or `--scaffold` flag to force scaffolding mode
4. Mise SHALL support a `--dry-run` flag to preview scaffolding without executing (if simple to implement)
5. Mise SHALL continue with existing validation mode if user declines scaffolding

### 2. Interactive Prompts
The scaffolding flow SHALL collect the following information with smart defaults:

**Required:**
- Project name/title (no default, user must provide)

**Optional (with defaults):**
- Repository visibility: `private` (default) | `public`
- Create GitHub remote: `yes` (default) | `no`
- License: `GPL-3.0` (default) | other SPDX identifier

**Auto-Generated:**
- Directory/slug name: kebab-case transformation of project title
  - Example: "My Cool Project" → "my-cool-project"
- GitHub account: User's personal account (no org selection)
- Default branch: Always `main`
- README: Always included

### 3. Interaction Style
1. Prompts SHALL use "press Enter to accept default" style (if easy to implement)
2. If smart defaults are difficult, fall back to simple step-by-step prompts
3. Prompts SHALL display the default value clearly: `Repository visibility [private]:`
4. User pressing Enter SHALL accept the default value
5. Invalid input SHALL re-prompt with error message

### 4. Template System
1. Templates SHALL be stored in `~/dev/comme-ca/scaffolds/project-init/`
2. Template files SHALL include:
   - `AGENTS.md` - Agent orchestration (copied from `scaffolds/high-low/`)
   - `CLAUDE.md` - Pointer to AGENTS.md (copied from `scaffolds/high-low/`)
   - `README.template.md` - Project README with placeholders
   - `LICENSE.gpl.txt` - Default GPL-3.0 license text
   - `LICENSE.mit.txt` - Alternative MIT license text (if user selects)
   - `gitignore.template` - Standard .gitignore patterns
3. Templates SHALL support placeholder substitution:
   - `{{PROJECT_NAME}}` - User-provided title
   - `{{PROJECT_SLUG}}` - Kebab-case directory name
   - `{{YEAR}}` - Current year (for license)
   - `{{GIT_USER_NAME}}` - From `git config user.name`
   - `{{GIT_USER_EMAIL}}` - From `git config user.email`

### 5. Scaffolding Actions
Mise SHALL perform the following actions in order:

1. **Create directory structure:**
   ```
   project-slug/
   ├── .git/              (via git init)
   ├── AGENTS.md
   ├── CLAUDE.md
   ├── README.md
   ├── LICENSE
   ├── .gitignore
   └── SPECS/
       ├── requirements.md
       └── design.md
   ```

2. **Initialize Git:**
   - Run `git init`
   - Set default branch to `main`

3. **Populate files:**
   - Copy and process templates with placeholder substitution
   - Add concise header comments to `SPECS/requirements.md` and `SPECS/design.md` explaining their purpose

4. **Create initial commit:**
   - Commit message format: `Initialize <project-name>`
   - Include all scaffolded files in commit

5. **Create GitHub remote (if user approved):**
   - Run `gh repo create <slug> --<visibility> --source=. --remote=origin`
   - Push initial commit to remote

### 6. Spec File Templates
The scaffolded `SPECS/requirements.md` SHALL contain:
```markdown
<!--
This file defines WHAT needs to be built.
Document user stories, functional requirements, constraints, and success criteria.
See: ~/dev/comme-ca/prompts/roles/menu.md for guidance.
-->

# Requirements

## Overview
[Project description goes here]

## User Stories
- As a [user type], I want [goal] so that [benefit]

## Functional Requirements
1. The system SHALL [requirement]

## Constraints
- [Technical or business constraint]

## Success Metrics
- [Measurable outcome]
```

The scaffolded `SPECS/design.md` SHALL contain:
```markdown
<!--
This file defines HOW it will be built.
Document architecture, component design, data models, and technical decisions.
See: ~/dev/comme-ca/prompts/roles/menu.md for guidance.
-->

# Design

## Architecture Overview
[High-level description]

## Component Breakdown
### Component A
- **Purpose:** [What it does]
- **Dependencies:** [What it needs]

## Data Models
[Schema definitions]

## Testing Strategy
[Approach to testing]
```

### 7. Validation & Error Handling
Mise SHALL validate the following before scaffolding:

1. **Directory state:**
   - ❌ Abort if `.git/` already exists
   - ⚠️ Warn if directory is not empty (allow user to continue or abort)

2. **Required tools:**
   - ❌ Abort if `git` not installed → Offer instructions to install
   - ⚠️ Warn if `gh` CLI not installed and user wants GitHub remote → Offer instructions or fallback to manual remote setup

3. **Git configuration:**
   - ❌ Abort if `git config user.name` or `user.email` not set → Offer instructions to configure

4. **GitHub authentication (if creating remote):**
   - ❌ Abort if `gh auth status` fails → Offer instructions: `gh auth login`

5. **Project name:**
   - ❌ Abort if empty or only whitespace → Re-prompt

**Error Handling Strategy:**
- For critical errors (git not installed, no git identity): Provide clear instructions and abort
- For optional features (GitHub remote): Offer to continue without the feature
- All error messages SHALL be actionable (include the command to fix)

### 8. Post-Scaffolding Actions
After successful scaffolding, Mise SHALL:

1. Print success summary:
   ```
   ✅ Repository initialized: my-cool-project
   📁 Location: /Users/username/my-cool-project
   🌐 GitHub: https://github.com/username/my-cool-project (if created)
   
   Next steps:
   • cd my-cool-project
   • plan    (Create feature specs)
   • Edit SPECS/requirements.md and SPECS/design.md to document your project
   ```

2. Offer optional next steps (user confirms yes/no):
   - Run Menu (plan) to create first feature spec
   - Install dependencies (if language-specific package manager detected)
   - Open in default editor

3. Hand control back to user (do not auto-execute unless confirmed)

### 9. Dry-Run Mode (Optional)
If simple to implement:
1. `prep --new --dry-run` SHALL display what would be created without executing
2. Output SHALL show:
   - Directory structure tree
   - File contents (or first few lines)
   - Git and GitHub commands that would run
3. User can review and then run without `--dry-run` to execute

## Non-Functional Requirements

### Usability
- Scaffolding flow SHALL complete in under 2 minutes for experienced users
- Default values SHALL cover 80% of use cases (minimal input required)
- Error messages SHALL be beginner-friendly with actionable instructions

### Maintainability
- Templates SHALL be separate files, not hardcoded in mise.md
- Template system SHALL be extensible for future language-specific variants
- Placeholder syntax SHALL be simple regex-based substitution

### Compatibility
- SHALL work on macOS, Linux (Windows support optional)
- SHALL support Fish, Zsh, and Bash shells
- SHALL gracefully degrade if GitHub CLI not available

## Constraints

### Technical Constraints
- Mise remains a read-mostly agent (scaffolding is creating, not modifying)
- All file operations SHALL be atomic (don't leave partial state on error)
- Templates SHALL use UTF-8 encoding

### Scope Constraints
- Mise SHALL NOT deploy projects (Vercel, Heroku, etc.)
- Mise SHALL NOT set up databases or external services
- Mise SHALL NOT install system dependencies (handled by existing Mise validation)
- Mise SHALL NOT write application code
- Mise SHALL NOT create GitHub issues, project boards, or Actions workflows

### Design Constraints
- Keep scaffolding minimal and opinionated
- Prefer smart defaults over configuration
- Maintain comme-ca philosophy: intelligence decoupled from infrastructure

## Success Metrics

### Quantitative
- Scaffolding completes successfully ≥95% of the time when requirements met
- Average time to scaffold: <60 seconds
- User provides <5 inputs on average (most use defaults)

### Qualitative
- New users can scaffold a project without reading documentation
- Scaffolded projects pass `audit` (Taste) on initial state
- Developers prefer using Mise scaffolding over manual setup

## Out of Scope
Explicitly NOT included in this feature:
- Language-specific project templates (Node.js, Python, Rust, etc.) - Future enhancement
- Multi-repository scaffolding (monorepos)
- Integration with project management tools (Jira, Linear, etc.)
- Custom template creation UI
- Remote template repositories
- CI/CD pipeline generation
- Docker/containerization setup
- Cloud deployment configuration
