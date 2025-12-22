27;2;13~CRITICAL CONTEXTUAL NOTE:
The following prompt, which I'll ask you to ingest and execute, was created by someone with no specific knowledge of this project and its specifics. Therefore, treat the instructions with a grain of salt and use your knowledge of this current project to extend or modify what the prompt says to do.

Don't take it overly literally. If there's any points of clarification, raise them with me and discuss and I will clarify my preferences. 

# Harness Audit & Serena Integration Prompt

## Context
You are auditing a sophisticated project planning and scaffolding harness to:
1. **Understand** how it currently uses MCPs (especially Serena)
2. **Identify gaps** in explicit Serena steering/prompting
3. **Generate recommendations** for integrating LSP-based targeted editing guidance

This audit must be compatible with multi-agent execution across **Gemini CLI**, **Cloud Code**, and **OpenAI Codex**.

***

## Part 1: Harness Architecture Discovery

### 1.1 Core Structure & Purpose
Please analyze and document:

- **Harness Type**: What is the primary purpose? (e.g., "Multi-agent planning framework," "MCP orchestrator," "Code generation pipeline")
- **Entry Points**: How does someone invoke this harness? (e.g., CLI command, config file, environment variable, programmatic API)
- **Root Directory Structure**: List the top-level directories and their purposes
  ```
  Example:
  harness/
  ├── agents/        # Agent definitions
  ├── templates/     # Code scaffolding templates
  ├── tools/         # Custom tools & executors
  ├── config/        # Configuration schemas
  └── docs/          # Documentation
  ```

### 1.2 MCP Integration Points
Document all MCPs used:

```yaml
MCPs:
  - name: "Serena"
    purpose: ""  # e.g., "LSP-based symbol manipulation"
    invocation: ""  # e.g., "via tool_use" or "via prompt context"
    current_steering: ""  # e.g., "Implicit in prompts" or "Explicit in system prompt"
    location_in_harness: ""  # e.g., "tools/serena.yaml" or "agent_config.json"

  - name: "[OTHER MCP]"
    purpose: ""
    invocation: ""
    current_steering: ""
    location_in_harness: ""
```

### 1.3 Agent Definitions
For each agent in the harness, list:

- **Agent Name**: (e.g., "planner", "architect", "executor", "refactorer")
- **System Prompt**: Paste the full system prompt (or key excerpt if very long)
- **Available Tools**: Which MCPs/tools can this agent invoke?
- **Output Format**: What does this agent produce? (JSON, markdown, YAML, code)
- **Downstream Use**: Who consumes this agent's output? (Another agent? The harness itself? A human?)

***

## Part 2: Serena Steering Audit

### 2.1 Current Serena Usage
Search your harness for all mentions of "Serena" or related patterns:

```
grep -r "serena\|LSP\|symbol\|insert_after\|replace_symbol" . --include="*.md" --include="*.yaml" --include="*.json" --include="*.py" --include="*.ts" --include="*.js"
```

For each occurrence, document:
- **Location**: (file path + line number)
- **Context**: (the surrounding text)
- **Purpose**: (why is Serena mentioned here?)

### 2.2 Explicit vs. Implicit Serena Guidance

**Explicit Steering** = Direct instructions to an agent about *when* and *how* to use Serena.
```
Example (Explicit):
"You have access to the Serena MCP for precision editing. For ALL refactoring tasks, 
use Serena's insert_after_symbol or replace_symbol tools instead of native file rewrites."
```

**Implicit Steering** = Serena is available as a tool, but agents are not explicitly told *when* to prefer it.
```
Example (Implicit):
Agent has Serena in tool_choice, but the system prompt says "Refactor the codebase" 
without specifying Serena > file rewrite.
```

Please assess:
- Is Serena mentioned in any **system prompt**? (Yes / No)
- Is there **conditional logic** that says "Use Serena when X, use native file write when Y"? (Yes / No)
- Are there **examples** in the prompts showing Serena usage? (Yes / No)
- Is Serena marked as **preferred_tool** in agent config? (Yes / No)

***

## Part 3: Execution Model & Workflow

### 3.1 Planning → Execution Flow
Describe the flow:

```
Agent 1 (Plan) → [Output Format: ?] → Agent 2 (Execute) → [Output: ?]
```

- **Does Plan output include explicit instructions for Serena?** (e.g., "Use Serena to insert method at symbol X")
- **Can the Executor agent read & parse the Plan?** (Does it have schema validation?)
- **Does the Executor check if a mutation should use Serena vs. native write?**

### 3.2 Template System
If the harness includes code templates:

- **Where are templates stored?** (Path)
- **How are they selected?** (By language, by pattern, by agent decision?)
- **Do templates include LSP-aware insertion hints?** (e.g., `<!-- INSERT_AFTER: class_declaration -->`)
- **Can templates be consumed directly by Serena?** (Yes / No)

***

## Part 4: Cross-Agent Compatibility

### 4.1 Agent Rotation (Gemini CLI, Cloud Code, Codex)
Your harness must work across these backends:

- **Gemini CLI**: Stateless, tool_use via MCP
- **Cloud Code**: IDE-integrated, file-watching capable
- **OpenAI Codex**: Function calling, no native MCP support

For each agent, document:
- **Can it run in Gemini CLI?** (Requires: MCP tools available)
- **Can it run in Cloud Code?** (Requires: File system access, optional)
- **Can it run in Codex?** (Requires: Serializable function definitions)

**Question**: Does your harness have *backend-specific versions* of agents, or is there a *compatibility layer*?

***

## Part 5: Output & Recommendations Format

### 5.1 Self-Assessment
Based on your analysis above, answer:

1. **Is Serena steering currently explicit or implicit?**
2. **What percentage of mutations could be improved by using Serena?** (Estimate)
3. **Are there agents that do file rewrites without checking Serena first?**
4. **Does the Planning agent output include LSP-aware hints for the Executor?**

### 5.2 Configuration Export
Provide the following files (or excerpts):

```
harness/
├── config/
│   ├── agents.yaml           # (List all agents + system prompts)
│   ├── mcp_config.yaml       # (All MCP definitions)
│   └── workflow.yaml         # (Planning → Execution flow)
├── templates/
│   └── [sample template]     # (One example that shows structure)
├── docs/
│   └── ARCHITECTURE.md       # (High-level overview if exists)
└── [Any other key file]
```

***

## Instructions for Use

### How to Run This Audit

**Option A: Manual Exploration** (Recommended for first pass)
1. Read through each section above.
2. Manually explore your harness directory structure.
3. Copy the structure and findings into a document.
4. Paste the output back here.

**Option B: Automated Audit** (If you have scripting)
If your harness includes a `audit.sh` or similar, run it:
```bash
cd /path/to/harness
./audit.sh > harness_audit_output.txt
```

**Option C: Agent-Driven Audit** (Using your own harness)
If you want to "eat your own dog food," run this prompt itself in your harness:
```bash
gemini --agent=auditor --input=harness_audit_prompt.md --output=harness_audit_result.md
```

***

## Expected Output

Once you've completed the audit, paste the results, and I will provide:

1. **Gap Analysis**: Where Serena steering is missing
2. **Prompt Recommendations**: Explicit steering text for each agent type
3. **Workflow Modifications**: How to wire Serena into Planning → Execution
4. **Backend Compatibility Check**: How to make it work in Gemini CLI, Cloud Code, and Codex
5. **Execution Examples**: Sample interactions showing the improved flow

***

## Notes

- **Sensitive Data**: If your harness contains secrets, API keys, or proprietary logic, redact them.
- **Length**: This audit may be long. Feel free to compress repetitive sections.
- **Schema**: If your harness uses formal schemas (JSON Schema, Protocol Buffers, etc.), include them—they help me understand the contract between agents.
- **Ambiguity**: If a section is unclear, document your best guess and flag it as "Uncertain: [reason]".

Sources
