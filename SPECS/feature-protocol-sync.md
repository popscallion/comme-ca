<!--
@id: feature-protocol-sync
@version: 1.0.0
@model: gemini-2.0-flash
-->
# Feature: Protocol Synchronization

## Context
`comme-ca` acts as both a **Distro** (static templates) and a **Living Protocol** (evolving methodology). A friction point exists where "Best Practices" discovered in downstream projects cannot easily be harvested, and upstream Protocol updates cannot be easily distributed to existing projects without manual patching.

## Goal
Implement a Two-Way Synchronization architecture that allows:
1.  **Upstream -> Downstream:** Projects to inherit "Universal Directives" and Core Role logic from a system-level Protocol Registry, minimizing drift.
2.  **Downstream -> Upstream:** The `tune` role to "Harvest" local process improvements into feedback artifacts for the Core Protocol.

## Design

### 1. The Protocol Registry (`~/.comme-ca/protocol/`)
*   **Concept:** A system-level versioned store of the core protocol files.
*   **Structure:**
    ```text
    ~/.comme-ca/protocol/
    ├── v1.3.0/
    │   ├── AGENTS.core.md
    │   ├── prompts/
    │   └── scaffolds/
    └── latest -> v1.3.0
    ```

### 2. Refactored `AGENTS.md` (The Shim Pattern)
*   **Concept:** Project-level `AGENTS.md` files should be lightweight "Shims" that reference the Core Protocol rather than duplicating it.
*   **Mechanism:** Since Markdown lacks native imports, we will use a directive that Agents (and `cca`) can parse.
*   **Example:**
    ```markdown
    <!-- @protocol: comme-ca @version: 1.4.0 -->
    # Agent Orchestration
    
    <!-- @import: core/AGENTS.md -->
    
    ## Project Specific Overrides
    ...
    ```

### 3. `tune` as "The Harvester"
*   **Responsibility:** When `tune` analyzes a session, it actively looks for *deviations* from the protocol that yielded better results.
*   **Output:** Generates `_INBOX/protocol-feedback-[topic].md` with:
    *   **Observation:** "We ignored the nested design template."
    *   **Outcome:** "Reduced friction, clearer docs."
    *   **Proposal:** "Flatten DESIGN.template.md."

### 4. `mise` as "The Maintainer"
*   **Responsibility:** On `prep`, `mise` checks the project's Protocol Version against the System "latest".
*   **Action:**
    *   If `Project < System`: Offers to "Transpile" or "Patch" the local shims.
    *   If `Project > System` (rare, dev mode): Warns of "Ahead of Protocol".

## Implementation Plan
1.  **Scaffold Registry:** Create the `~/.comme-ca/protocol` structure and populate it with the current state of `feature/agentic-abstractions`.
2.  **Update `mise`:** Add logic to check versions and reference the Registry.
3.  **Update `tune`:** Add the "Harvest" directive to its prompt.
4.  **Refactor Templates:** Update `scaffolds/` to use the Shim pattern for `AGENTS.md`.
