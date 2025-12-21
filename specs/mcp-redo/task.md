> **NOTE (2025-12-21):** This research is partially superseded by the **Serena** integration (see `prompts/capabilities/serena.md`). The "Surgical Editor" capability implements a form of safe tool execution pattern. Future work on this spec should evaluate if Serena covers the needs or if a full "App Server" pattern is still required.

Now let me search for specific guidance on MCP tool filtering and migration patterns:

Perfect! I found very relevant information. Let me search for more specific details on Claude's agents.md and Skills architecture.

### Phase 2 – Search-Backed Answer

I've found concrete solutions and migration strategies. Here's what you need to know:

---

## **1. Tool Filtering / Masking Solutions**

Instead of a middleman, you have better options:

**Option A: MCP Funnel (Proxy Approach)**
- **MCP Funnel** is an MCP proxy server that aggregates multiple MCP servers with **fine-grained tool filtering**
- Connects to multiple backends, applies filtering rules, exposes only what you need
- Architecture: `Claude → MCP Funnel → [filtered tools] → Multiple MCP servers`
- You can hide specific tools or use wildcard patterns (e.g., disable all "dangerous" tools, keep only read-only)
- Automatically handles tool namespacing to prevent conflicts

**Option B: Server-Side Tool Disabling (Best Practice)**
- MCP servers should implement individual tool disable/enable flags
- Sam McLeod's research shows this dramatically reduces token consumption:
  - AWS Terraform Server: 6.4k tokens for all 7 tools → disable Terragrunt → saves 1.1k tokens
  - AWS Cost Explorer: 9.1k tokens, selectively disable unnecessary tools
- This is the recommended approach per the Claude Code community feedback

**Option C: Filesystem Control (Code Execution Pattern)**
- Simply don't include unwanted tools in your `./servers/` directory
- Only populate `./servers/google-drive/` with the specific tool files you need
- Prevents agent from even discovering hidden tools

---

## **2. Migrating Existing Projects to Code Execution + MCP**

### **Current Structure (Old Pattern)**
```
your-project/
├── AGENTS.md                 # Agent config with MCP refs
├── agents/
│   └── main-agent.md
└── config/
    └── mcp-config.json      # Lists all MCP servers & tools
```

### **New Structure (Code Execution Pattern)**
```
your-project/
├── AGENTS.md                 # Updated with new pattern
├── agents/
│   └── main-agent.md        # Updated instructions
├── servers/                  # NEW: Filesystem-based MCP API
│   ├── google-drive/
│   │   ├── getDocument.ts
│   │   ├── listFiles.ts
│   │   └── index.ts
│   ├── salesforce/
│   │   ├── updateRecord.ts
│   │   ├── createLead.ts
│   │   └── index.ts
│   └── ... (other servers)
├── skills/                   # NEW: Reusable agent code
│   ├── SKILL.md             # Metadata
│   ├── data-sync.ts         # Reusable function
│   └── report-generator.ts
└── workspace/               # NEW: Execution state
    ├── leads.csv
    └── .state.json
```

---

## **3. Migration Agent Prompt**

Use this prompt with Claude Code to auto-migrate your project:

```markdown
# Agent: MCP to Code Execution Migration Assistant

## Objective
Migrate an existing MCP agent project from the traditional direct-tool-calling pattern 
to the efficient code execution + MCP pattern described in Anthropic's 
"Code execution with MCP" article.

## Context
Your project currently uses:
- `AGENTS.md` that lists MCP servers and their tools upfront
- Direct tool calling (model calls MCP tools → results flow back to model)
- Tools in configuration files rather than filesystem-discoverable structure

You need to convert this to:
- `./servers/` directory structure where each tool is a file
- Code execution environment where the agent writes code to orchestrate MCP calls
- `./skills/` folder for persistent, reusable agent-written functions
- Reduction in token consumption by 90%+ in complex workflows

## Migration Steps

### 1. Audit Current Configuration
**Input**: User's current `AGENTS.md` and `mcp-config.json` (or equivalent)

Extract:
- List of all MCP servers currently configured
- Count of tools per server
- Which tools are actually used vs. dead weight
- Authentication/environment variables needed

**Output**: `migration-audit.md` documenting the above

### 2. Create Filesystem Structure
For each MCP server, create `./servers/<server-name>/`:

```typescript
// Example: ./servers/google-drive/getDocument.ts
import { callMCPTool } from "../../../client.js";

interface GetDocumentInput {
  documentId: string;
  fields?: string[];
}

interface GetDocumentResponse {
  id: string;
  title: string;
  content: string;
  metadata: Record<string, unknown>;
}

/**
 * Retrieve a document from Google Drive
 * @param input - Document ID and optional fields to return
 * @returns Document object with content and metadata
 */
export async function getDocument(
  input: GetDocumentInput
): Promise<GetDocumentResponse> {
  return callMCPTool("google_drive__get_document", input);
}
```

**Create `./servers/<server-name>/index.ts`** that exports all tools from that server.

**Omit tools you don't need** — this is your filtering mechanism.

### 3. Update AGENTS.md
Replace MCP server listings with:

```markdown
# Available Servers

Agents discover available tools by exploring the `./servers/` directory.
Tool definitions are loaded on-demand as code files.

## Filesystem Structure

- `./servers/google-drive/` - Google Drive integration
  - `getDocument.ts` - Read documents
  - `listFiles.ts` - List files in Drive
  
- `./servers/salesforce/` - Salesforce integration
  - `createLead.ts` - Create a lead
  - `updateRecord.ts` - Update records
  
## Code Execution Guidelines

1. Import tool functions from `./servers/`
2. Write code to orchestrate multiple tools in the execution environment
3. Filter/aggregate large data locally before returning to model
4. Use loops and conditionals in code rather than chaining tool calls
```

### 4. Create Migration Helper Skill
Create `./skills/mcp-workflow-template.ts`:

```typescript
// Reusable pattern for common workflows
import * as gdrive from "../servers/google-drive";
import * as salesforce from "../servers/salesforce";

/**
 * Example: Sync documents from Google Drive to Salesforce
 */
export async function syncDriveToSalesforce(
  config: { driveFolder: string; salesforceObject: string }
) {
  // Discover: List available files
  const files = await gdrive.listFiles({ folderId: config.driveFolder });
  
  // Process: Filter and transform locally
  const docsToSync = files.filter((f) => f.mimeType === "document");
  
  // Execute: Update Salesforce with batched operations
  const results = [];
  for (const doc of docsToSync) {
    const content = await gdrive.getDocument({ documentId: doc.id });
    const updated = await salesforce.updateRecord({
      objectType: config.salesforceObject,
      data: { SourceDocument: content.content },
    });
    results.push(updated);
  }
  
  return { synced: results.length, details: results };
}
```

Create `./skills/SKILL.md`:

```yaml
name: MCP Workflow Templates
description: Reusable code patterns for common MCP orchestration tasks
tags: [mcp, orchestration, workflow]
version: "1.0.0"
```

### 5. Test Migration
Create a test script to verify:
```bash
# Can the agent discover all servers?
ls -la ./servers/

# Can it import and call tools?
import * as gdrive from './servers/google-drive'
// Verify getDocument is callable

# Is there a working skill?
ls -la ./skills/
// Verify SKILL.md exists
```

## Instructions to Agent

When user provides their project:

1. **Analyze** `AGENTS.md` and existing MCP config
2. **Audit** which MCP servers/tools are actually used
3. **Generate** the new `./servers/` filesystem structure with TypeScript wrapper files
4. **Update** `AGENTS.md` with new pattern documentation
5. **Create** at least one reusable skill from common workflows
6. **Output summary**: Token reduction estimates, warnings about unused tools to remove
7. **Provide migration steps** the user should follow manually (security approval, env vars)

## Important Notes

- **Don't execute code**, just generate files for user review
- **Preserve all MCP server connections** but surface them as filesystem APIs
- **Flag risky/unused tools** that could be filtered out
- **Ask about secrets/env vars** handling (should not appear in code files)
- **Estimate token savings** based on tool count reduction and local filtering opportunities
```

---

## **4. Key Differences from Your Old Middleman Approach**

| Aspect | Your Old Middleman | New Pattern |
|--------|-------------------|------------|
| **Filtering location** | Custom middleware | Filesystem control + optional MCP Funnel proxy |
| **Tool discovery** | All tools exposed, then filtered | Only exposed tools appear in `./servers/` |
| **Context usage** | Model still sees all descriptions | Model discovers tools on-demand |
| **Data flow** | Middleman intercepts & transforms | Execution environment processes data |
| **Reusability** | One-off middleman per project | Persistent skills across projects |

---

#### **TLDR**
- **Tool filtering**: Use MCP Funnel proxy or disable tools server-side; filesystem control is built-in to code execution pattern
- **Migration**: Convert MCP servers → `./servers/` directory with TypeScript wrapper files; update AGENTS.md; create Skills for reusable workflows
- **Prompt provided**: Use the migration agent prompt above to auto-generate filesystem structure, reducing tokens 90%+ and enabling tool orchestration in code instead of model context
