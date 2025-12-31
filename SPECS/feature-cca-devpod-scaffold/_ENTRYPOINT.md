<!--
@id: feature-cca-devpod-scaffold-entrypoint
@version: 0.1.0
@model: codex
-->

# Iteration Dashboard: CCA DevPod Scaffold (Default-On)

| Status | Description | Owner |
| :--- | :--- | :--- |
| **Pinned** | Spec created; implementation blocked pending comme-ca sync | Codex |

## Scope
Extend `cca init` to apply DevPod/Ona-ready scaffolding by default, while supporting explicit flags:
- `--no-container` (opt-out)
- `--init-git` (initialize git if missing)
- `--force` (apply scaffold despite conflicts)

## Tasks
- [ ] Define CLI interface for `cca init` (default-on, opt-out flag).
- [ ] Add scaffold application steps (devcontainer defaults, `.ona` symlinks, hooks).
- [ ] Add idempotent patching logic (no destructive overwrites).
- [ ] Add tests or manual verification steps for a fresh repo.
- [ ] Coordinate with comme-ca maintainers before implementation (PIN).

## Refinements Roadmap
1. Improve devcontainer patching to avoid duplicate `--env-file` pairs and to merge `postCreateCommand` arrays safely.
2. Add explicit guidance when `.gitignore` exists but `.git/` does not (suggest `--init-git`).
3. Provide concise drift summary when scaffold files exist but differ.
4. Add optional `--container-profile <name>` (later).
5. Add scripted tests for flows A–D under `tests/`.

## Notes
- This is intentionally pinned; do not implement until the comme-ca sync decision is confirmed.
