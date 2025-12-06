# Role Bugs

This file tracks issues related to agent roles and role‑based execution within the comme‑ca system.

---

## Bug 1 — Goose Role: Cannot See or Execute Slash Commands

**Source:** Goose agent  
**Description:**  
When asked to run `/prep`, the Goose role reports that it *cannot see or execute slash commands at all*.  
It treats slash commands as plain text and cannot initiate role‑specific workflows, even when those workflows exist.

**Observed Behavior Snippet:**
> “I don’t have direct access to run the `/prep` command…”  
> “I can’t execute commands on my own; I can only guide you…”  
> “What would you need in order to be able to run prep?”  

**Impact:**  
Role workflows depending on slash command triggers cannot be invoked, blocking environment‑setup automation and TODO‑tracker updates.

**Status:**  
Unresolved — needs investigation into command routing inside the role engine.

---

## Bug 2 — Crush Role: Does Not Recognize Slash Commands Either

**Source:** Crush agent  
**Description:**  
The Crush role also fails to detect or react to slash commands (e.g., `/prep`, `/build`, `/run`).  
This mirrors the Goose bug, indicating a shared bug in the role‑command dispatch layer.

**Observed Behavior:**  
Crush ignores the slash command entirely and behaves as if no executable directive was provided.

**Impact:**  
Breaks comme‑ca’s operational workflow, since Crush is expected to run system‑level processes and automated checks.

**Status:**  
Unresolved — likely same root cause as Goose bug. Needs unified fix in command parser/dispatcher.

---