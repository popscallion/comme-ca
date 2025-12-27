<!--
@id: lab-distro-sync
@version: 1.0.0
@model: gemini-2.0-flash
-->

# Lab-to-Distro Sync Workflow

## 1. Executive Summary
**One Sentence Pitch:** A streamlined CLI command to promote stable prompts from the Private Lab (`comment-dit-on`) to the Public Distro (`comme-ca`).
**Target Audience:** Core contributors managing the split-repository architecture.
**Core Value:** Reduces the friction of "releasing" prompt updates, ensuring version alignment and reducing manual git operations.

## 2. Requirements

### Functional
1.  **Publish Command:** `cca publish` (run from Lab).
2.  **Validation:**
    *   Check that local prompts are committed.
    *   Check for semantic version bumps (using `@version` metadata).
3.  **Execution:**
    *   Copy modified files to `../comme-ca/prompts/`.
    *   Update `../comme-ca/AGENTS.md` if orchestration rules changed.
    *   Trigger a commit in `comme-ca`.

### User Stories
- As a maintainer, after testing a new `menu.md` in the Lab, I want to run one command to ship it to the Distro.

## 3. Technical Constraints
- **Pathing:** Assumes `../comme-ca` relative path (standard dev setup).
- **Permissions:** Requires local write access to the Distro repo.

## 4. Assumptions & Defaults
- **Assumption:** The user keeps both repos side-by-side.
- **Default:** Only publish prompts that have changed.

## 5. Open Questions
- **Unknown:** How to handle `scaffolds/` updates?
- **Impact:** If `AGENTS.md` changes in Lab, the *scaffold* in Distro needs updating, not just the root file.
- **Recommendation:** The publish script needs to map Lab paths to Distro Scaffold paths explicitly.

## 6. Implementation Roadmap
1.  **Map Paths:** Define the source-to-destination map (Lab -> Distro Scaffolds).
2.  **Scripting:** Create `bin/publish` in the Lab repo.
3.  **Integration:** Add to `cca` CLI wrapper.
