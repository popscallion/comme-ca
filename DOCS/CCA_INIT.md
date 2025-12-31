<!--
@id: cca-init
@version: 0.1.0
@model: codex
-->
# CCA Init Behavior

## Overview
`cca init` bootstraps comme-ca scaffolding. By default it also applies DevPod/Ona container scaffolding unless explicitly disabled.

## Flags
- `--no-container`: disable DevPod/Ona container scaffold (default is enabled).
- `--init-git`: initialize a git repo if `.git/` is missing, then install hooks.
- `--force`: apply DevPod/Ona container scaffolding even when conflicts are detected.

## Flow Matrix

### A) Empty directory (no files, no `.git/`)
- Copies base scaffold files.
- Creates `_INBOX/`, `DOCS/`, `SPECS/`, `SPECS/_ARCHIVE/`.
- Applies DevPod/Ona scaffold if no `.devcontainer/` exists.
- Does **not** install hooks (no git repo). Prompts to re-run with `--init-git` if hooks are desired.

### B) Existing non-scaffolded git repo
- Copies base scaffold files (if not already present).
- Installs `commit-msg` hook if missing.
- Applies DevPod/Ona scaffold:
  - Create `.devcontainer/devcontainer.json` if missing.
  - If `.devcontainer` exists, apply safe patching only.

### C) Existing scaffolded repo, out of date
- Runs minimal checks:
  - `AGENTS.md` drift (existing `cca update` behavior is the source of truth).
  - Devcontainer missing `runArgs: ["--env-file", ".env"]`.
  - Missing `.ona` symlink setup in `postCreateCommand`.
  - Missing `commit-msg` hook.
- If changes are safe to apply: apply and report.
- If conflicts are detected: report and prompt to re-run with `--force`.

### D) Existing scaffolded repo, up to date
- No changes. Report a clean state.

## Conflict Policy
- Do not overwrite user config by default.
- Treat manual `postCreateCommand` edits as potential conflicts.
- When conflicts are detected, emit a summary and require `--force-devpod`.
