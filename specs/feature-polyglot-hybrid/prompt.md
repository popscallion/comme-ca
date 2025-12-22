@AGENTS.md @README.md @scaffolds/high-low/

You are acting in the **Menu (Plan)** role.

**Objective:**
I need you to design a new scaffold template for this repository (likely to be placed in `scaffolds/polyglot-hybrid/`) that operationalizes the "Polyglot Development Ecosystem" described in the Evolutionary Decision Record (EDR) below.

**Context:**
We are currently in the `comme-ca` repository, which serves as the source of truth for agent orchestration and project scaffolding. We want to add a new "power-user" scaffold that supports a hybrid Rust/Swift/Python/JS workflow with shared tooling.

**Instructions:**
1.  **Analyze the EDR:** Read the "Evolutionary Decision Record" provided below to understand the required architecture (Shared Infrastructure, Justfile, Polyglot directory layout, LLM-first workflow).
2.  **Investigate Existing Patterns:** Explore the `scaffolds/` directory (specifically `scaffolds/high-low`) to understand how we currently structure templates (e.g., how `AGENTS.md` is distributed, where dotfiles live).
3.  **Gap Analysis:** Identify what files are missing from our current `high-low` scaffold that are required for this new Polyglot architecture (e.g., `Justfile`, `.pre-commit-config.yaml`, `packages/` directory structure).
4.  **Deliverable:** Create a `specs/polyglot-scaffold/design.md` file that outlines:
    *   The proposed directory structure for the new scaffold.
    *   The contents of the shared `Justfile` (abstracting `cargo`, `npm`, `swift`, etc.).
    *   How the `AGENTS.md` should be modified (if at all) to support this workflow.
    *   A plan to implement this new scaffold.

**The Evolutionary Decision Record (The Gloss):**

### 1. Executive Summary
We have defined a **Polyglot Development Ecosystem** designed to leverage JS/TS and Python skills while integrating **Rust** for high-performance hardware/core logic and **Swift** for native Apple platform capabilities. The workflow is centered on an **LLM-Augmented Development Cycle** using Zed and Ghostty.

### 2. System Architecture (The "Law")
#### The Macro View: Polyglot Orchestration
To manage JS/TS, Python, Rust, and Swift simultaneously, the environment relies on **Shared Infrastructure** wrapping **Language-Specific Runtimes**.
*   **Unified Interface:** A `Justfile` serves as the entry point. Commands like `just test` or `just build` abstract the underlying `cargo`, `npm`, or `swift` calls.
*   **LLM Integration:** A standardized prompt library in Zed/Ghostty allows the LLM to generate idiomatic code by referencing the project's shared `.editorconfig` and linting rules.
*   **CI/CD:** A single GitHub Actions workflow matrix handles testing across all four languages.

#### Directory Structure Concept
*   `Justfile` (The Orchestrator)
*   `packages/js`
*   `packages/py`
*   `packages/rust`
*   `packages/swift`
*   `scripts/` (Shared utilities)
*   `.editorconfig` (Unified style)

### 3. Feature Specification
*   **UI Layer (Swift/SwiftUI):** Handles View/Input/Apple APIs.
*   **Core Logic (Rust):** Handles business logic/hardware.
*   **Bridge:** C-compatible API or UniFFI.

**Action:**
Start your research now. Do not write implementation code yet; focus on the design spec.
