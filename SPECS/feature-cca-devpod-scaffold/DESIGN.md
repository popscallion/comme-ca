# Design: CCA DevPod Scaffold (Default-On)

## Decision
Implement **Option 1**: extend `cca init` with DevPod/Ona scaffolding **enabled by default**, with an explicit opt-out flag: `--no-container`.

## Proposed Flow
1. `cca init` copies existing base scaffold files (current behavior).
2. If DevPod scaffold is enabled (default):
   - Ensure `.devcontainer/devcontainer.json` includes `runArgs: ["--env-file", ".env"]`.
   - Ensure `postCreateCommand` creates `.ona/secret_bundle` and `.ona/secret-bundle.env` symlinks.
   - Install `scaffolds/project-init/hooks/commit-msg` into `.git/hooks/` when missing.
3. If the repo already has a devcontainer or hooks:
   - Apply minimal patch or warn; do not overwrite.

## Flags
- `--no-container`: disable DevPod/Ona container scaffold.
- `--init-git`: run `git init` when `.git/` is missing; then install hooks.
- `--force`: apply DevPod/Ona container scaffold even when conflicts are detected.

## Flow Behavior (Detailed)
### A) Empty directory
- Apply base scaffold files.
- Apply DevPod/Ona scaffold if `.devcontainer/` missing.
- Do not install hooks; prompt to re-run with `--init-git` if hooks are desired.

### B) Existing non-scaffolded git repo
- Apply base scaffold files if missing.
- Install hooks if missing.
- Apply DevPod/Ona scaffold if safe.

### C) Existing scaffolded repo, out of date
- Run minimum checks:
  - Devcontainer missing `runArgs: ["--env-file", ".env"]`.
  - Missing `.ona` symlink creation in `postCreateCommand`.
  - Missing `commit-msg` hook.
- If safe, apply patches; if conflict, report and prompt to re-run with `--force`.

### D) Existing scaffolded repo, up to date
- No changes; report clean state.

## Implementation Notes
- Prefer a patch-based approach (detect existing JSON and mutate keys).
- Add a small helper to append to `postCreateCommand` when present.
- Avoid non-portable shell syntax in the inserted command.

## Pin
Do not implement until comme-ca sync decision is confirmed.
