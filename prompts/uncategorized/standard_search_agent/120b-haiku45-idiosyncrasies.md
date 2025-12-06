# Rationale for Prompt Divergence: OSS-120b vs. Haiku 4.5 (v2)

This document outlines the strategic reasoning behind splitting the System Prompt into two distinct architectures. It incorporates findings from stress-testing on Cerebras (OSS-120b) and semantic edge cases (Haiku 4.5).

The core finding remains: **OSS-120b requires explicit constraints (The Engineer)**, while **Haiku 4.5 requires contextual framing (The Consultant)**.

---

## 1. The OSS-120b Optimization ("The Forensic Engineer")

**Core Philosophy:** OSS-120b is a literalist state machine. It excels when given strict "Negative Constraints" (what *not* to do) and rigid schema definitions. It fails when allowed to "improvise" or when it encounters ambiguity in tool definitions.

### A. Cerebras Stability Hardening (New)
*Testing revealed that the ultra-fast inference of Cerebras amplifies logic errors and context overflows.*

1.  **The Integer Crash Fix (`revisesThought: 0`)**
    *   **Failure:** OSS-120b tried to be helpful by filling optional fields with `0`. The MCP Pydantic validation failed because these fields expect `null` or a specific integer `>0`.
    *   **Modification:** Added a **TOOL SCHEMA SAFETY** section with a specific negative constraint: *"NEVER set optional fields to 0 or null. OMIT THEM."*
    *   **Rationale:** We must override the model's training bias to "fill in the blanks."

2.  **The Enum Hallucination Fix (`search_depth: "auto"`)**
    *   **Failure:** At lower creativity, the model hallucinated an `"auto"` parameter for Tavily, assuming a default that doesn't exist in the API.
    *   **Modification:** Hardcoded valid Enums in the prompt: *"search_depth must be 'basic' or 'advanced'."*
    *   **Rationale:** We cannot rely on the model's internal knowledge of API specs; we must treat the prompt as the API documentation.

3.  **The "Planning Loop" Fix**
    *   **Failure:** At high/medium creativity, the model would get stuck calling `sequential_thinking` recursively (planning to plan), burning tokens without acting.
    *   **Modification:** Added a **Forbidden Rule**: *"You are FORBIDDEN from calling `sequential_thinking` more than ONCE per Phase 2 turn."*
    *   **Rationale:** Hard constraints are necessary to stop recursive logic loops in reasoning models.

4.  **The Silent Context Crash (Tavily Garbage)**
    *   **Failure:** The model crashed silently when Tavily returned massive raw HTML blobs (e.g., Product Hunt footers).
    *   **Modification:** Enforced `include_raw_content: false` and aggressive `exclude_domains` (Scribd, Product Hunt) in the tool definition.
    *   **Rationale:** Cerebras has strict output/context limits; we must sanitize inputs *before* they reach the model's context window.

### B. Logic & Flow Refinements (Updated)

1.  **The "Zombie Consent" Fix**
    *   **Modification:** Added `CRITICAL OUTPUT RULE: In Phase 2, do NOT ask for consent.`
    *   **Rationale:** Persists from v1. OSS-120b requires explicit instructions to stop pattern-matching its Phase 1 behavior.

2.  **The Syntax vs. Semantics Trigger**
    *   **Modification:** The "Override Rule" now listens for semantic keywords (`search`, `verify`, `check`) alongside punctuation (`?`).
    *   **Rationale:** Users rarely use perfect syntax. The prompt must recognize intent.

3.  **Perplexity Enforcement**
    *   **Modification:** `VALIDATION` is a mandatory step in the protocol.
    *   **Rationale:** OSS-120b minimizes effort by default. We must force it to cross-check Tavily results against Perplexity to ensure accuracy.

---

## 2. The Haiku 4.5 Optimization ("The Senior Consultant")

**Core Philosophy:** Haiku 4.5 is intelligent but prone to "Helpfulness Bias" (ignoring rules to solve the problem fast) and over-correction (becoming "dumb" when restricted). The v3 prompt balances **Structure** with **Intuition**.

### A. The "Lobotomy" Reversal (New)
*Testing revealed that strictly forbidding "native thinking" caused Haiku to fail at basic semantic tasks (e.g., correcting "two blur" to "tubular").*

1.  **Restoring Semantic Inference**
    *   **Failure:** The v1 prompt instruction *"You do NOT have native thinking capabilities"* caused the model to interpret typos literally to comply with the "No Thinking" rule.
    *   **Modification:** Added an **SEMANTIC INFERENCE** section: *"Use context to infer intended meaning. Do not be literal."*
    *   **Rationale:** We need to distinguish between "Deep Reasoning" (which requires the Tool) and "Basic Intuition" (which the model should do natively).

2.  **"Triage" Terminology**
    *   **Modification:** Reframed Phase 1 as **"The Triage"** instead of "The Draft."
    *   **Rationale:** "Triage" implies a *decision process* (Category A vs. Category B), which aligns better with the model's goal of helpfulness than "Drafting" (which implies incomplete work).

### B. The "Smart" Workflow (Updated)

1.  **The "Mystery" Hook**
    *   **Modification:** Explicitly branches logic:
        *   *Is this a Mystery?* -> Output **Hypothesis Table**.
        *   *Is this a Fact?* -> Output **Direct Answer**.
    *   **Rationale:** This forces the model to structure complex problems (like the "Sneezing Onion" case) immediately, preventing the unstructured "thinking crashes" observed in earlier tests.

2.  **Tool Chaining Strategy**
    *   **Modification:** Instructed `Chain Discovery tools -> Validation tool`.
    *   **Rationale:** Haiku is fast enough to execute multi-step chains in a single turn without timing out.

3.  **Schema One-Shotting**
    *   **Modification:** Kept the JSON example for `sequential_thinking`.
    *   **Rationale:** Haiku learns formatting best from examples, whereas OSS-120b learns best from rules.

---

## 3. Shared Upgrades (The "Sweet Spot" Features)

Both prompts share these features, implemented in their respective styles:

1.  **The Diagnostic Offer**
    *   **Mechanism:** Instead of a binary "Search y/n?", the models offer: "A) Verify with Search" or "B) Diagnose with Questions."
    *   **Rationale:** Captures the user's desire for interactive troubleshooting ("Sherlock Holmes mode") without forcing it on simple queries.

2.  **Artifact Density**
    *   **Mechanism:** Explicit instruction to prefer **Markdown Tables** and **Lists** over prose.
    *   **Rationale:** Increases information density and readability for technical users.

3.  **Hypothesis Identification**
    *   **Mechanism:** Mandatory numbering of hypotheses (`H1`, `H2`).
    *   **Rationale:** Enables efficient referencing in future conversation turns ("Rule out H1").

---

## 4. Configuration Recommendation

Based on the "Sweet Spot" analysis, these are the optimal runtime parameters:

| Parameter | OSS-120b (Cerebras) | Haiku 4.5 |
| :--- | :--- | :--- |
| **Creativity (Temp)** | **Medium (0.5)** | **Medium (0.5)** |
| **Reasoning Effort** | **Medium** | **Low (Native) / High (MCP)** |
| **Prompt Version** | `OSS Hardened v2` | `Haiku Intelligent Triage v3` |

*   **OSS Notes:** Low Creativity causes Enum hallucinations; High causes Logic Loops. Medium is the only stable state.
*   **Haiku Notes:** Native Reasoning Effort is redundant with MCP; keep Native Low to preserve latency, let the MCP handle the depth.
