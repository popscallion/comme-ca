# Instructions for Installing the "Pass" Role

You are now in the `comme-ca` repository root (`~/dev/comme-ca`).

## Mission
Your goal is to integrate the new "Pass" role and `_ENTRYPOINT.md` protocol into the `comme-ca` system.

## Input Files
*   `pass.md`: The prompt definition for the new role.
*   `PRD.md`: The specification explaining the logic.

## Tasks

1.  **Install the Role:**
    *   Copy `pass.md` to `prompts/roles/pass.md`.

2.  **Update AGENTS.md (The Protocol):**
    *   Edit `scaffolds/high-low/AGENTS.md`.
    *   **Add Role:** Add "Pass (wrap)" to the "Standard Roles" table.
    *   **Add Alias:** Add `alias wrap="..."` to the "Setting Up Aliases" section.
    *   **Add Usage:** Add `wrap` to the "Usage" section.
    *   **Add Context Rule:** In "Context Detection", add `_ENTRYPOINT.md` as a **Mandatory** context file that must exist.

3.  **Update Scaffolding (The Prep):**
    *   Create `scaffolds/project-init/_ENTRYPOINT.template.md` (Use the structure from the PRD).
    *   Edit `prompts/roles/mise.md`:
        *   Add logic to check for `_ENTRYPOINT.md` in *any* directory.
        *   Add logic to generate `_ENTRYPOINT.md` from template during `cca init` / scaffolding.

4.  **Update Audit (The Taste):**
    *   Edit `prompts/roles/taste.md`:
        *   Add a check for `_ENTRYPOINT.md` existence and freshness.

5.  **Commit & Install:**
    *   Commit changes to `comme-ca`.
    *   Run `./bin/install` to update your local aliases and paths.

## Validation
*   Run `cca init` in a temp dir -> verify `_ENTRYPOINT.md` is created.
*   Run `wrap` (Pass) -> verify it updates docs and generates the handoff prompt.
