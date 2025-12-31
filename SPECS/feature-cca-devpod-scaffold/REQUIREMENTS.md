# Requirements: CCA DevPod Scaffold

## Functional Requirements
1. **Default-on**: `cca init` applies DevPod/Ona scaffold by default.
2. **Opt-out**: `cca init --no-container` disables scaffold changes.
3. **Git hooks**: Hook install is automatic only when `.git/` exists or `--init-git` is used.
4. **Idempotent**: Re-running `cca init` does not clobber user changes.
5. **Non-destructive**: Do not overwrite existing devcontainer or hooks without explicit user intent.
6. **Hook install**: If hooks are added, only install missing hooks or warn if conflicting.
7. **Conflict prompts**: If changes are unsafe, prompt to re-run with `--force`.

## Scaffold Content Requirements
1. **Devcontainer defaults**
   - `runArgs: ["--env-file", ".env"]`
   - `postCreateCommand`: create `.ona/secret_bundle` and `.ona/secret-bundle.env` symlinks
2. **Repo-local hooks**
   - Install `scaffolds/project-init/hooks/commit-msg` into `.git/hooks/` when absent.
3. **Compatibility**
   - Preserve existing `postCreateCommand` by appending or merging safely.
   - Avoid non-portable shell syntax in generated commands.

## Flow Requirements
1. **Empty dir**: Skip hook install; prompt to re-run with `--init-git`.
2. **Non-scaffolded git repo**: Install hook if missing; apply container scaffold if safe.
3. **Out-of-date scaffold**: Run minimal checks; apply safe patches; prompt to re-run with `--force-devpod` on conflict.
4. **Up-to-date scaffold**: No changes; report clean state.

## Policy
- Implementation is pinned until comme-ca sync completes.
