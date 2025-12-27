# Architecture Decision Record (ADR) & Product Requirements Document (PRD)
**Subject:** Adoption of Code Execution Architecture for MCP Agents

## 1. Executive Summary (The "Where We Landed")
We are transitioning from a **Direct Tool Calling** model to a **Code Execution with MCP** architecture. In this new paradigm, agents orchestrate Model Context Protocol (MCP) servers by writing and executing code in a sandboxed environment, rather than the model directly invoking tools via the context window.

This architectural shift was triggered by an analysis of Anthropic's "Code execution with MCP" methodology, which demonstrated a **98.7% reduction in token usage** for complex workflows.

**Key Outcome:** Agents will now interact with a **filesystem-based API** (`./servers/`) to discover and utilize tools on-demand, enabling local data processing, complex control flow, and persistent skill development (`./skills/`).

---

## 2. The "Spark" (Context & Evolution)
*   **Original Goal:** The user sought an explanation of Anthropic's article on code execution [read here](https://www.anthropic.com/engineering/code-execution-with-mcp) with MCP to understand its core value proposition.
*   **The Pivot:** The discussion revealed that this is not merely an optimization but a fundamental restructuring of the **Agent-Model relationship**. The user identified that this pattern solves critical scalability issues—specifically **context bloat** from excessive tool definitions and the difficulty of **masking/filtering unwanted tools** in standard MCP setups.
*   **The Relationship:** We are solving the **scalability and security limitations of multi-tool agents** by implementing the **Code Execution Architecture**, which decouples tool orchestration from the model's reasoning loop.

---

## 3. System Architecture (The "Law")

### Core Workflow
1.  **Discovery:** Agent explores `./servers/` directory to find available tool definitions (progressive disclosure).
2.  **Orchestration:** Model writes a script (TypeScript/Python) to coordinate multiple tools.
3.  **Execution:** Sandboxed environment runs the script, handling API calls, data filtering, and logic loops locally.
4.  **Result:** Only the final, processed output is returned to the model's context.

### Infrastructure Components
*   **Filesystem API (`./servers/`)**:
    *   Replaces giant JSON schemas in context.
    *   Each tool is a file (e.g., `getDocument.ts`).
    *   **Filtering Strategy:** Tools are exposed/hidden by their presence in this directory.
*   **Skill Library (`./skills/`)**:
    *   Persistent storage for reusable, agent-authored functions.
    *   Enables "learning" across sessions (per-project scope).
*   **Workspace (`./workspace/`)**:
    *   Ephemeral storage for intermediate data (CSVs, logs) that never enters the context window.

### Operational Risks & Requirements
*   **Sandboxing:** Execution environment must be strictly isolated (e.g., Docker, gVisor) to prevent host system compromise.
*   **Resource Limits:** CPU/RAM caps required to prevent infinite loops or memory exhaustion by agent scripts.
*   **State Management:** `./skills/` and `./workspace/` persistence policies must be defined (e.g., clear on reset vs. long-term storage).

---

## 4. Feature Specification (The "Instance")

### Migration Strategy: Legacy MCP to Code Execution
To transition existing projects, we will deploy a **Migration Agent** using the following specification.

#### Phase 1: Audit & Mapping
*   **Input:** Existing `AGENTS.md` and `mcp-config.json`.
*   **Action:** Identify all active MCP servers and their tools.
*   **Decision:** Flag unused or "risky" tools for exclusion (filtering).

#### Phase 2: Filesystem Generation
*   **Target:** Generate `./servers/<server_name>/` directory structure.
*   **Implementation:** Create TypeScript wrapper files for each approved tool.
    ```typescript
    // ./servers/google-drive/getDocument.ts
    import { callMCPTool } from "../../../client.js";
    export async function getDocument(input: GetDocumentInput) {
        return callMCPTool("google_drive__get_document", input);
    }
    ```

#### Phase 3: Configuration Update
*   **Action:** Rewrite `AGENTS.md` to remove static tool lists.
*   **New Instruction:** "Do not call tools directly. Explore `./servers/` to find tool definitions and write code to execute them."

#### Phase 4: Skill Seeding
*   **Action:** Create initial `./skills/SKILL.md` and `mcp-workflow-template.ts` for common patterns (e.g., "Fetch-Filter-Upload" loops).

---

## 5. Decision Record (Rationale)

### System Decisions
*   **Why Code Execution Architecture?**
    *   **Efficiency:** Decouples data processing from reasoning. Reduces token costs by orders of magnitude (e.g., 150k → 2k tokens).
    *   **Privacy:** Sensitive data (PII) can be filtered in the sandbox without ever entering the LLM's context.
    *   **Logic:** Enables loops, retries, and conditionals without expensive model round-trips.
*   **Why Filesystem-based Discovery?**
    *   **Scalability:** Solves the "Context Window Limit" problem. Agents load only what they need (Progressive Disclosure).
    *   **Control:** Provides a natural, file-based mechanism for filtering/masking tools (if the file isn't there, the agent can't use it).

### Feature Decisions
*   **Why Migration Agent?**
    *   Manual conversion of hundreds of tools to TypeScript wrappers is error-prone and labor-intensive. An automated agent ensures consistency and immediate adoption of the new pattern.
*   **Why Per-Project Skills?**
    *   Ensures domain specificity. Global skills risk polluting context with irrelevant capabilities, whereas project-scoped skills evolve with the specific task requirements.
