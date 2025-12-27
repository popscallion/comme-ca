# ENTRYPOINT (Iteration Dashboard)

## Current Status
We are in **Phase 3** (Protocol Synchronization & Rollout).
We have successfully implemented **Agentic Abstractions** (Agents/Subagents/Skills) and the **Protocol Sync** architecture (Registry/Shim/Harvest).

## 1. The Situation
The `comme-ca` system has evolved from a static template generator to a synchronized protocol.
- **Protocol Registry:** Located at `~/.comme-ca/protocol/dev`.
- **Shim Pattern:** New projects reference core docs instead of copying them.
- **Two-Way Sync:** `mise` patches downstream projects; `tune` harvests downstream improvements.

## 2. Testing Instructions (Verification)
See `docs/TESTING_PROTOCOL_SYNC.md` for detailed test cases.

### Quick Smoke Test
```bash
# 1. Sync local registry
cca setup:sync

# 2. Test new scaffolding (Shim)
mkdir -p ~/tmp/shim-test && cd ~/tmp/shim-test
cca init
cat AGENTS.md  # Should show @import directive
```

---

## 3. Active Specs
| Spec | Status | Focus |
|:-----|:-------|:------|
| `feature-protocol-sync` | ✅ Done | Registry, Shim, Harvest logic |
| `feature-agentic-abstractions` | ✅ Done | Core Agent/Subagent roles |
| `feature-mcp-redo` | 🟡 Active | Filesystem Discovery logic |

---
**Last Updated:** 2025-12-27 13:45
**Previous:** Agentic Abstractions & Protocol Sync Implementation