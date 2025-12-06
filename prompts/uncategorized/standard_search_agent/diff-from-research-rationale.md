# Rationale for Prompt Divergence: OSS-120b vs. Haiku 4.5

This document outlines the strategic reasoning behind splitting the original "Universal" System Prompt into two distinct architectures. The original prompt failed because it attempted to enforce a single set of rules on two models with fundamentally different cognitive architectures: one that requires **explicit instruction** (OSS-120b) and one that requires **contextual framing** (Haiku 4.5).

---

## 1. The OSS-120b Optimization ("The Forensic Engineer")

**Core Philosophy:** OSS-120b is a literalist. It failed the original prompt because it adhered to *syntax* over *intent* (the `?` bug) and lacked the "common sense" to override conflicting instructions (the "No Tools" bug). The new prompt treats the model as a strict **State Machine**.

### Key Modifications & Rationale

**A. The "Phase 1 Logic Trap" Fix**
*   **Original:** `Phase 1 Rules: Do not call ANY MCP tools.`
*   **Failure:** The model correctly identified `sequential_thinking` as a tool. Therefore, when asked to "think" in Phase 1, it refused, because "Thinking" violated the "No Tools" rule.
*   **Modification:** Explicitly categorized tools into **Planning** (Allowed) vs. **Discovery/Validation** (Banned).
*   **Rationale:** We must explicitly decouple "Reasoning" from "Searching" in the model's definitions to allow deep thought without triggering a search.

**B. The "Zombie Consent" Fix**
*   **Original:** The prompt instructed the model to ask for consent in Phase 1 but didn't explicitly *forbid* it in Phase 2.
*   **Failure:** OSS-120b pattern-matched its Phase 1 behavior and repeated the question "Would you like me to search?" at the end of Phase 2, even after it had just searched.
*   **Modification:** Added a **CRITICAL OUTPUT RULE**: `In Phase 2, do NOT ask for consent.`
*   **Rationale:** OSS-120b requires negative constraints to break pattern-completion loops.

**C. The "Syntax vs. Semantics" Trigger Fix**
*   **Original:** `If the trimmed query begins OR ends with “?”...`
*   **Failure:** The user input "answer with search" (no question mark) caused the model to default to Phase 1 because the syntax check failed, despite the semantic intent being clear.
*   **Modification:** Expanded the trigger logic to include semantic keywords: `"verify", "search", "find", "check"`.
*   **Rationale:** We cannot rely on users to use proper punctuation. We must hard-code the semantic triggers we expect.

**D. The Perplexity Enforcement**
*   **Original:** Listed Perplexity as `optional`.
*   **Failure:** OSS-120b rarely chose to use it, favoring the first tool in the list (Tavily).
*   **Modification:** Created a `VALIDATION` category and mandated a specific workflow: `DISCOVERY -> VALIDATION`.
*   **Rationale:** OSS-120b is procedural. If we want it to double-check facts, we must make "Validation" a mandatory step in the procedure, not an option.

---

## 2. The Haiku 4.5 Optimization ("The Senior Consultant")

**Core Philosophy:** Haiku 4.5 is intelligent but impatient. It failed the original prompt because it disregarded "Rules" that blocked it from being helpful (searching immediately). The new prompt treats the model as a **Partner**, using "Principles" and "Context" rather than rigid constraints.

### Key Modifications & Rationale

**A. The "Impatience" Fix (Phase 1 Reframing)**
*   **Original:** `Phase 1 Rules (No Tools)`
*   **Failure:** Haiku felt the best way to answer was to search, so it ignored the rule.
*   **Modification:** Reframed Phase 1 as **"The Draft"** under **"Low-Latency Constraints."**
*   **Rationale:** Anthropic models respond better to *contextual reasons* ("We are optimizing for speed/cost") than arbitrary rules ("Don't do X"). By explaining *why* it shouldn't search (speed), we align its goal function with ours.

**B. The Schema Hallucination Fix (`nextThoughtNeeded`)**
*   **Original:** `CRITICAL VALIDATION RULE: All fields revisesThought...`
*   **Failure:** Haiku often forgot parameters or hallucinated new ones because abstract descriptions are low-signal for it.
*   **Modification:** Provided a **One-Shot JSON Example** in the `TOOL COMPLIANCE STANDARDS`.
*   **Rationale:** Haiku is a strong in-context learner. Showing it *one* perfect example of a tool call is more effective than writing three paragraphs describing the schema.

**C. The "Sleuth" Workflow Integration**
*   **Original:** Generic "Answer the query."
*   **Failure:** Haiku would write prose paragraphs instead of structured analysis.
*   **Modification:** Explicitly injected the **Hypothesis Generation** logic: `Is this a Mystery? -> Create Numbered Hypothesis Table`.
*   **Rationale:** Haiku excels at synthesis. By forcing it into a tabular format ("ID | Hypothesis | Signal"), we leverage its intelligence to structure the problem before it tries to solve it.

**D. Tool Chaining Strategy**
*   **Original:** `Call Tavily and/or Exa... Optionally call Perplexity.`
*   **Failure:** Haiku would often just pick one and be done.
*   **Modification:** Instructed: `Chain Discovery tools -> Validation tool`.
*   **Rationale:** Haiku is fast enough to run multiple tools without timing out. We explicitly instruct it to treat Perplexity as a "Stress Test," appealing to its reasoning capability to find contradictions.

---

## 3. Shared Upgrades (The "Sweet Spot" Features)

Both prompts received these global upgrades based on your feedback regarding the "Interactive Sleuth" flow:

1.  **The "Diagnostic" Hook:**
    *   **Rationale:** We replaced the binary "Search y/n?" with a branching offer: "Verify (Search)" OR "Diagnose (Questionnaire)." This captures the user's desire for the model to come up with tests/signals for hypotheses.
2.  **Artifact Density:**
    *   **Rationale:** Both prompts now explicitly demand `Markdown tables, numbered lists, and headers` over prose. This addresses the feedback to be "terse but detailed."
3.  **Hypothesis Identification:**
    *   **Rationale:** Added the rule `Hypotheses must be Numbered (H1, H2)` to allow for easy referencing in multi-turn conversations (e.g., "Rule out H2").


## later mods for hardening cerebras 120b against tool call bugs
### **Why this fixes the specific errors:**

1.  **Integer Crash Fix:** The section `TOOL SCHEMA SAFETY` explicitly shows the model the "Bad" (`"revisesThought": 0`) and "Good" (Field removed) pattern. This is a "Negative Constraint" which is highly effective for correcting specific regressions.
2.  **Enum Fix:** Explicitly defines the valid set for `search_depth` (`"basic" | "advanced"`).
3.  **Loop Fix:** Adds a "Forbidden" rule for calling the planner more than once.
4.  **Citation Fix:** Adds `Citations` to the Critical Output Rules.

### **Configuration Recommendation for Cerebras**
*   **Model:** OSS-120b (Llama-3-70b-Instruct or similar variant usually hosted).
*   **Creativity:** **Medium (0.5)**. (Low caused the Enum hallucination; High caused the Loop).
*   **Reasoning Effort:** **Medium**. (High caused the Loop and Verbosity).
*   **Prompt:** The Hardened Prompt above.
