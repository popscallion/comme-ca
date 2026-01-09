 Skill: Agent Context Refactor

  Trigger: Use this skill when AGENTS.md (or the primary system prompt file) exceeds 200 lines,
  contains mixed concerns (architecture + rules + tutorials), or when agent adherence to
  protocols is low.

  Goal: Transform a "Textbook" (read once, forgotten) into a "Directive" (referenced constantly,
  strictly followed).

  ---

  Phase 1: Taxonomy & Routing

   1. Read & Inventory: Read the target file completely. List every H2/H3 section.
   2. Classify Content: Tag each section with one of these types:
       * DIRECTIVE: A hard rule (e.g., "Use TypeScript", "Never use npm"). -> KEEP.
       * PROTOCOL: A multi-step procedure (e.g., "How to debug", "Merge Checklist"). -> MOVE to
         docs/protocols/.
       * CONTEXT: Static facts (e.g., "Tech Stack", "Folder Structure"). -> MOVE to design.md or
         README.md.
       * TUTORIAL: Educational content (e.g., "How to use Stagehand"). -> MOVE to docs/guides/ or
         docs/testing.md.
   3. Verify Destinations: Check if the target destination files already exist. If not, plan to
      create them.

  Phase 2: Extraction & Modularization

   1. Create Protocol Files:
       * Extract detailed procedures into focused files (e.g., docs/AGENT-PROTOCOL.md,
         docs/BRANCH-PROTOCOL.md).
       * Why: Agents can read these on demand (read_file docs/PROTOCOL.md) instead of polluting
         their context window permanently.
   2. Update SSOT (Single Source of Truth):
       * Move architectural details to design.md.
       * Move setup/install instructions to README.md.
   3. Consolidate Testing:
       * Move all testing tools, guardrails, and error patterns into docs/TESTING-GUARDRAILS.md.

  Phase 3: Hardening (The "Secret Sauce")

  Inject these 7 Critical Policies into the new, slim AGENTS.md or docs/AGENT-PROTOCOL.md:

   1. Context Scoping: "Use sub-agents (e.g., delegate_to_agent) to explore context before
      acting."
   2. Docs Discipline: "Check docs/INDEX.md before writing. Prune obsolete docs."
   3. Sequential Thinking: "For non-trivial tasks, you MUST use sequentialthinking to plan."
   4. Read-Before-Write: "Always read a file's current state before editing."
   5. Negative Constraints: "Explicitly FORBID dangerous paths (e.g., 'CRITICAL: DO NOT run
      npm')."
   6. Error Directiveness: "Error messages must be copy-pasteable commands (e.g., 'Run
      fix-script.sh')."
   7. Idempotency: "All scripts must be safe to run multiple times without side effects."

  Phase 4: The Rewrite

  Overwrite AGENTS.md with a High-Level Directive format (< 100 lines):

   * Header: Critical Constraints (Runtime, Language).
   * Core Links: Pointers to the files created in Phase 2 (design.md, docs/AGENT-PROTOCOL.md).
   * Operating Mode: The policies from Phase 3.
   * Emergency Recovery: "If X fails, run Y."

  ---

  Example Prompt to Agent

  > "Please apply the Agent Context Refactor Skill to this repository. Read AGENTS.md, classify
  the content into Directives vs Protocols/Context, move the detailed procedures to docs/, and
  rewrite AGENTS.md to be a strict, lean directive file containing only high-level rules and
  links. Ensure you inject the 7 Critical Policies (Idempotency, Negative Constraints, etc.) into
  the new structure."
