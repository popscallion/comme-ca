# OSS-120B Search Agent – Product Requirements Document

**Version:** v3 (Hardened)
**Last Updated:** 2025-12-07
**Implementation:** `research-cerebras120b.md`

---

## Overview

This document describes the behavior of a **state-machine search orchestrator** built on **OSS-120B (Cerebras)** optimized for:
- High-speed generalist research
- Robust tool use with quality gating
- Protection against common failure modes (truncation, off-topic results, domain spam)

### Architecture: Two-Phase State Machine

**Phase 1: Preliminary Analysis (Internal Knowledge)**
- No tools permitted
- Generates hypothesis tables for complex queries
- Offers user consent for web search

**Phase 2: Search-Backed Answer (External Data)**
- Tool stack: `sequential_thinking` → `tavily` + `exa` → `perplexity`
- Quality-gated results (relevance threshold, domain filtering)
- Structured markdown output with citations

---

## Core Capabilities

### 1. Intent Recognition
- Handles typos, slang, ambiguity (e.g., "two blur" → "tubular")
- Infers intended meaning from context
- Not pedantic about phrasing

### 2. Tool Safety (v3 Hardening)
- **Domain Exclusion:** Blocks `scribd.com`, `pinterest.com`, `slideshare.net`, `producthunt.com`, `facebook.com`, `lg.com`
- **Relevance Gating:** Discards Tavily results with score < 0.15
- **Truncation Handling:** Marks partial sources as `[Partial]`, no recursive fetch
- **Language Filter:** Auto-retry with `.com/.org` if >50% non-English

### 3. Output Format
- **Artifacts over Prose:** Markdown tables, numbered lists, headers
- **No Leaks:** No raw XML tags (`<think>`, `<analysis>`)
- **Numbered Hypotheses:** H1, H2, H3 format
- **Mandatory Citations:** All facts cite source index (e.g., `[1]`)

---

## Interaction Flow

### Phase 1: Preliminary Analysis

**Trigger:** New query (no tools)

**Behavior:**
1. Analyze complexity
2. If **Problem/Mystery**: Output hypothesis table
3. If **Simple**: Concise answer + offer search

**Example Output:**
```markdown
### Phase 1 – Preliminary Analysis (Unverified)
| ID | Hypothesis | Probability |
|----|------------|-------------|
| H1 | DNS resolution issue | 65% |
| H2 | Firewall blocking port | 25% |
| H3 | Backend service down | 10% |

#### TLDR
• Most likely DNS misconfiguration based on symptoms

I haven't searched yet. Would you like me to:
A) Look this up? (y/n)
B) Create a diagnostic questionnaire? (type "test")
```

---

### Phase 2: Search-Backed Answer

**Trigger:** User consent ("y", "search") or direct request

**Protocol:**
1. Call `sequential_thinking` **ONCE** to plan
2. Call **DISCOVERY** tools (Tavily for facts, Exa for concepts)
3. Call **VALIDATION** tool (Perplexity for cross-checking)
4. Synthesize into markdown with citations
5. **DO NOT** ask for consent again (prevents "Zombie Consent" bug)

**Example Output:**
```markdown
### Phase 2 – Search-Backed Answer
*Verification: H1 confirmed by multiple sources*

- DNS resolution failures account for 60% of connection errors in distributed systems [1]
- Common causes include TTL misconfigurations and stale cache entries [2]
- Tools like `dig` and `nslookup` are standard diagnostics [3]

Sources:
1. DNS Best Practices (https://example.com/dns)
2. Cloudflare Debugging Guide (https://cloudflare.com/debug)
3. IETF RFC 1035 (https://ietf.org/rfc1035)

```json
{
  "error": {"code": "NONE"}
}
```

TLDR
• DNS misconfiguration confirmed, use `dig` for diagnosis
```

---

## Tool Routing Strategy

### Tavily (Discovery - Facts)
**Use for:**
- Discrete facts (dates, names, numbers)
- Entity-centric queries (companies, products, people)
- Time-sensitive information (current prices, recent events)

**Parameters:**
- `search_depth`: `"basic"` or `"advanced"` (NEVER `"auto"`)
- `include_raw_content`: `false` (prevents overflow)
- `exclude_domains`: See hardening list above

### Exa (Discovery - Concepts)
**Use for:**
- Research questions (methods, approaches, themes)
- Literature summaries
- Architectural patterns

### Perplexity (Validation)
**Use for:**
- Cross-checking facts from Tavily/Exa
- Resolving contradictions
- Final verification pass

### Sequential Thinking (Planning)
**Required** at start of Phase 2
- **Called ONCE only** (loop prevention)
- Plans search strategy before execution
- Omits optional fields (`revisesThought`, `branchFromThought`) unless needed

---

## Quality Gates (v3)

### Result Quality Gating
1. **Relevance Threshold:** `score < 0.15` → discard
2. **Language Filter:** If >50% non-English → retry with `"site:.com OR site:.org"`
3. **Zero-Result Handling:** Output: `"No confident answer found. Please refine your query..."`

### Truncation Protocol
1. Mark source as `[Partial]` in citations (e.g., `[1 - Partial]`)
2. Do NOT attempt recursive fetch (causes loops)
3. Prioritize complete sources in synthesis
4. If only partial sources: State `"Answer based on incomplete data"`

### Source Validation
**Only cite sources that:**
- Are NOT in exclude_domains list
- Have relevance score ≥ 0.15 (Tavily) or clear topical match (Exa/Perplexity)
- Are not marked as `[Partial]` unless no complete sources exist

---

## Critical Constraints

### Loop Prevention
- **FORBIDDEN** from calling `sequential_thinking` > 1 time per Phase 2 turn
- Plan once, then execute

### Schema Safety
- **Sequential Thinking:** If optional fields unused, **OMIT THEM** (don't set to `0` or `null`)
- **Tavily:** ALWAYS set `include_raw_content: false`
- **Country Field:** Do NOT include in Tavily calls

### Output Rules
1. **Artifacts over Prose:** Use tables/lists
2. **No Leaks:** No raw XML or "analysis:" prefixes
3. **No Zombie Questions:** Don't re-ask for consent in Phase 2
4. **Hypothesis ID:** Must be numbered (H1, H2, H3)
5. **Citations:** Every fact must cite source index
6. **Source Validation:** Enforce quality gates above

---

## Failure Modes & Resolutions

| Failure | Symptom | Resolution (v3) |
|---------|---------|-----------------|
| **Truncated Content** | `<error>Content truncated</error>` | Mark `[Partial]`, no recursive fetch |
| **Off-Topic Results** | Low-relevance Tavily matches | Discard score < 0.15 |
| **Language Contamination** | Non-English pages (e.g., lg.com/jp) | Domain block + language filter retry |
| **Schema Crash** | `revisesThought: 0` causes error | Hardcoded OMIT rule |
| **Zombie Consent** | Re-asking "Would you like me to search?" | Explicit "DO NOT ask" rule in Phase 2 |
| **Tool Loops** | Multiple `sequential_thinking` calls | FORBIDDEN > 1 call per turn |

---

## Testing & Validation

See `test-harness-spec.md` for full validation protocol.

**Key Test Cases:**
1. Truncation handling (long docs)
2. Relevance gating (broad queries)
3. Language filtering (product support queries)
4. Domain exclusion enforcement

---

## Version History

### v3 (2025-12-07) - Hardened
- Added domain exclusions: `facebook.com`, `lg.com`
- Implemented quality gating (score threshold 0.15)
- Added truncation protocol
- Enforced source validation in output rules

### v2 (Prior)
- State machine architecture (Phase 1/2)
- Tool schema safety rules
- Intent recognition
- Loop prevention

### v1 (Original)
- Basic Phase 1/2 consent model
- Tavily + Exa routing
- JSON schema output

---

## Related Documents

- **Implementation:** `research-cerebras120b.md` (system prompt)
- **Architecture:** `adr.md` (decision record)
- **Testing:** `test-harness-spec.md` (validation suite)
- **Bugs:** `bugs_120b.md` (resolved issues)
