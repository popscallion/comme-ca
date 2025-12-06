**[Internal Classification]:** Engineering/Ops

### 1. Executive Summary
*   **Consensus:** A "Universal System Prompt" is non-viable for distinct model architectures; optimal performance requires bifurcating strategies into a **"Consultant" prompt (Haiku 4.5)** that relies on context/principles and a **"State Machine" prompt (OSS-120b)** that relies on explicit rules/constraints.
*   **Catalyst:** The divergent failure modes observed during the "Knee Dysplasia" behavioral analysis test—OSS-120b failed via rigid literalism (Temperature 0) or hallucination (Temperature 0.8), while Haiku 4.5 failed via "helpfulness" overriding low-latency constraints.
*   **Scope:** Configuration of System Prompts, Inference Parameters (Temperature/Reasoning Effort), and Tool Definitions for robust Agentic workflows.

### 2. Conversation Arc
*   **Trigger:** User observed erratic behavior: "Zombie Consent" (asking to search after searching), "Silent Failures" (crashing on tool outputs), and "Leaky Thoughts" (raw XML tags in output).
*   **Pivot:** The investigation revealed that **Temperature 0** lobotomized OSS-120b's lateral thinking (missing the pain-behavior link), while strict "No Thinking" rules lobotomized Haiku's semantic inference (misinterpreting typos).
*   **Relationship:** *We are addressing stability and reasoning quality by tailoring the prompt structure to the specific cognitive architecture of each model.*

### 3. Key Resources & References
*   **[Haiku 4.5 Optimized Prompt (v3)](path/to/prompt)** – "The Intelligent Triage" (Context-heavy, inference allowed).
*   **[OSS-120b Hardened Prompt (v2)](path/to/prompt)** – "The Cerebras State Machine" (Rule-heavy, schema hardened).
*   **[Tavily API Docs](https://docs.tavily.com)** – Reference for `exclude_domains` and `include_raw_content` constraints.

### 4. Macro-Context (System Architecture)
*   **Haiku 4.5 ("The Consultant"):**
    *   **Architecture:** Intuitive, fast, instruction-following.
    *   **Optimization:** Responds best to **Principles** ("Triage First") and **One-Shot Examples**.
    *   **Failure Mode:** "Helpfulness Bias" (Ignoring constraints to solve the user's problem immediately).
*   **OSS-120b/Cerebras ("The Forensic Engineer"):**
    *   **Architecture:** Procedural, literal, high-throughput.
    *   **Optimization:** Responds best to **Negative Constraints** ("Do NOT..."), **State Machines** (Phase 1 vs 2), and **Explicit Schema Definitions**.
    *   **Failure Mode:** "Pedantic Literalism" (Low Temp) or "Instruction Drift" (High Temp).

### 5. Micro-Application (Implementation Details)
*   **Parameter Tuning:**
    *   **Creativity (Temperature):** **Medium (0.4–0.6)** is the global optimum. Low (0) causes logic loops and artifact leaks; High (0.8+) causes tool hallucinations.
    *   **Reasoning Effort:** **Medium** for OSS (stability); **Low (Native)** + **High (MCP)** for Haiku.
*   **Critical Bug Fixes:**
    *   **Tavily Crash:** Enforced `include_raw_content: false` and `exclude_domains` to prevent context overflow on Cerebras.
    *   **Schema Crash:** Hardcoded `revisesThought: OMIT` rules to prevent OSS-120b from sending `0` (Integer) where `null` was expected.
    *   **"Zombie Consent":** Added specific output rule: `In Phase 2, do NOT ask for consent.`
    *   **Typos/Slang:** Added **"Intent Recognition"** block to allow models to fix "two blur" -> "tubular" without triggering heavy reasoning tools.

### 6. Rationale & Decision Record
*   **Why Bifurcate?**
    *   Haiku needs permission to *guess* (Semantic Inference) to be smart.
    *   OSS-120b needs strict *prohibitions* (Forbidden Tools) to remain stable.
    *   A single prompt could not satisfy both requirements without causing regression in one.
*   **Synthesis Logic:**
    *   **Phase 1 (Triage):** Restructured to force **Hypothesis Generation** (Tables) for complex queries, satisfying the user's need for "Sherlock Holmes" behavior without premature searching.
    *   **Tooling:** Explicitly assigned **Perplexity** to a `VALIDATION` role to force cross-checking, as OSS-120b was ignoring it.

### 7. Constraints & Preferences
*   **OSS Provider:** **Cerebras** (Ultra-fast inference masks latency but requires strict token discipline).
*   **Output Style:** **Artifact-Heavy** (Tables, Lists, Headers) over Prose.
*   **Citation Style:** Bracketed `[1]` links mandatory in Phase 2.

### 8. Open Questions & Assumptions
*   **Unknown:** Whether OSS-120b will maintain "One-Shot Planning" discipline over very long context windows (>10 turns).
*   **Assumption:** The `tavily` API will remain the primary source of context overflow errors, necessitating aggressive filtering (`exclude_domains`).
