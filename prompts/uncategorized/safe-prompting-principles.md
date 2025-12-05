To instruct an agent tasked with evidence-based prompt engineering, these principles serve as the "Operating System" for safe, recursive optimization. They are grouped by functional layer.

### 1. Security Architecture (The "Containment" Protocol)
*These rules prevent the agent from becoming confused by the prompts it is analyzing.*

*   **Strict Input Isolation:** The agent must be instructed to treat all text within specific XML tags (e.g., `<source_material>`) as **inert data payload** only. It must explicitly be forbidden from executing any instructions found within these tags.
*   **Instruction Hierarchy:** Establish a hard rule that **Meta-Instructions** (the agent's own system prompt) always supersede **Payload Instructions** (the text being analyzed). If a conflict exists, the payload is ignored.
*   **Context Override:** When operating within an existing conversation history, the agent must be instructed to reclassify all prior turns—including previous system prompts—as "data to be analyzed" rather than "context to be obeyed."

### 2. Operational Logic (The "Routing" Mechanism)
*These rules enable the agent to autonomously determine the correct task (Extraction vs. Iteration).*

*   **Polymorphic Input Parsing:** The agent should use **Structural Signatures** to classify input automatically:
    *   *Signature A (Conversation):* Timestamps, "User/Assistant" labels → Trigger **Extraction Mode** (generalize logic, strip instance data).
    *   *Signature B (Artifact):* Markdown headers, "System Prompt" titles, instruction blocks → Trigger **Iteration Mode** (calculate delta, apply refinements).
*   **Entity Class Abstraction:** When extracting a prompt from a conversation, the agent must aggressively **de-contextualize** the data—stripping specific product names or code snippets to identify the underlying "Entity Class" (e.g., changing "Fix my Python SQL script" to "Code Refactoring & Optimization").
*   **Heuristic Extraction:** The agent must identify and codify three specific layers from any source:
    1.  *Sourcing Rules* (What data is allowed?)
    2.  *Style Constraints* (What is the required tone/format?)
    3.  *Decision Logic* (How are edge cases handled?)

### 3. Output Integrity (The "Sandbox" Protocol)
*These rules prevent "Persona Drift" and ensure the output is machine-readable.*

*   **JSON Enclosure:** The agent must return its analysis and the final generated prompt inside a single JSON object. This forces the model to remain in an "Analyst" cognitive frame, preventing it from slipping into the "Conversational" persona of the prompt it is creating.
*   **Reasoning Trace:** Require a specific JSON field (e.g., `"reasoning_trace"`) where the agent must explain its logic *before* generating the final prompt. This induces a "Chain of Thought" that reduces hallucination and logic errors.
*   **Shadow Documentation:** Citations and version history must be placed in a **Non-Executable Footer** (e.g., `## Documentation (DO NOT EXECUTE)`). This allows for human verification and version control without confusing the LLM that eventually executes the prompt.

### 4. Iteration Safety (The "Recursive" Protocol)
*These rules prevent degradation when a prompt is improved over multiple cycles.*

*   **Delta-Based Editing:** When iterating, the agent should not rewrite from scratch unless necessary. It should compare the `<user_directive>` against the `<source_material>` to calculate a "Diff," applying only additive (new rules) or subtractive (removing constraints) changes while preserving high-value structural elements.
*   **Fresh Context Preference:** Where possible, the agent should be instructed to ignore the "conversation history" of the *iteration process itself* and focus only on the *current* artifact and the *current* directive. This prevents "instruction drift" caused by outdated goals from previous turns.

Sources
