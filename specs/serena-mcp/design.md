# Serena MCP Integration Design

## 1. Architecture Overview

The integration treats Serena MCP as a **Micro-Service for Edits**, stripping away its "Agent" persona. We will use a configuration-first approach to lock Serena into a "Headless Tool" mode.

```mermaid
graph TD
    User[Gemini CLI / Claude Code] -->|MCP Protocol| wrapper[Wrapper / Alias]
    wrapper -->|Exec| Docker[Serena Container / Process]
    Docker -->|Read/Write| FS[Local Filesystem]
    Docker -->|Load| Config[serena_config.yml]
```

## 2. Configuration Strategy

We will use a **Global Configuration** approach for portability.

- **Config Path:** `~/.config/serena/headless.yml`
- **Tool Selection:** Whitelist the 13 specific tools.
- **Mode Selection:** Enforce `no-onboarding` and `no-memories`.

## 3. Implementation Details

### A. Claude Code JSON Snippet
This snippet is designed to be pasted into `~/.claude/config.json` (or equivalent plugin manifest).

```json
{
  "mcpServers": {
    "serena-headless": {
      "command": "uvx",
      "args": [
        "--from",
        "git+https://github.com/oraios/serena",
        "serena",
        "start-mcp-server",
        "--config",
        "${HOME}/.config/serena/headless.yml",
        "--mode",
        "no-onboarding",
        "--mode",
        "no-memories"
      ]
    }
  }
}

### B. The Wrapper Script (`bin/serena-lite`)
A script to launch the server with the correct flags, abstracting the complexity.

```bash
#!/bin/bash
# Pseudocode for wrapper
serena start-mcp-server \
  --mode no-onboarding \
  --mode no-memories \
  --disable-tools rename_symbol,rename_file,debugger,lint,format,run_tests \
  --port 8000
```

### B. Docker Option (Preferred for Stability)
An alias or script that spins up the container.

```bash
docker run -d \
  -v $(pwd):/app/workdir \
  -v ~/.config/serena/config.yml:/app/config.yml \
  oraios/serena:latest \
  start-mcp-server --config /app/config.yml
```

## 4. Integration with comme-ca

- **Tool Definition:** We will add a `serena-lite` entry to the Gemini/Claude MCP configuration files (`~/.gemini/settings.json`, `~/.claude/config.json`).
- **Scaffolding:** The `prep` role will check for the presence of the `serena` executable or Docker image if this spec is active.

## 5. Verification Plan
1.  **Startup Test:** Launch server, verify no "Onboarding" prompt appears.
2.  **Edit Test:** Send a JSON MCP request to `find_symbol`, verify correct location returned.
3.  **Isolation Test:** Verify `.serena/memories` is NOT created.

```