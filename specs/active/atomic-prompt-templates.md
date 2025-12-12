<!--
@id: atomic-prompt-templates
@version: 1.0.0
@model: gemini-2.0-flash
-->

# Atomic Prompt-Template Coupling

## 1. Executive Summary
**One Sentence Pitch:** A validation mechanism that ensures Generative Prompts (Sources) and Static Templates (Destinations) remain strictly synchronized to prevent silent data loss.
**Target Audience:** Maintainers of `comme-ca` and prompt engineers.
**Core Value:** Prevents the "Ghost Data" problem where an agent generates rich content (e.g., "Discarded Alternatives") that disappears because the destination template has no slot to receive it.

## 2. Requirements

### Functional
1.  **Schema Definition:** We must define a schema for what a Prompt outputs (Output Slots) and what a Template expects (Input Slots).
2.  **Validation Tool:** A script or agent audit step that compares `prompts/utilities/*.md` against `scaffolds/project-init/*.template.md`.
3.  **Enforcement:**
    *   **Level 1 (Soft):** `audit` warns if headers don't match.
    *   **Level 2 (Hard):** CI fails if a Prompt is updated without a corresponding Template update.

### User Stories
- As a prompt engineer, when I add a "Security Concerns" section to `why.md`, the system alerts me that `design.template.md` is missing a receiving header.

## 3. Technical Constraints
- **Stack:** likely a simple parser in `bin/` or a logic rule in `audit` (Taste).
- **Format:** Markdown header parsing (`## Header`).

## 4. Assumptions & Defaults
- **Assumption:** Matching Markdown Headers (String Equality) is a sufficient proxy for schema matching.
- **Default:** If a header exists in Prompt Output but not Template, it is considered a "Leak."

## 5. Open Questions
- **Unknown:** How do we handle "Optional" output sections from prompts?
- **Impact:** False positives in the validator.
- **Recommendation:** Need a way to annotate optionality in the Prompt definition.

## 6. Implementation Roadmap
1.  **Manual Audit:** Map current `what`/`why` outputs to `requirements`/`design` templates.
2.  **Audit Rule:** Update `taste.md` to check this manually.
3.  **Automated Tool:** Build `cca check:templates`.
