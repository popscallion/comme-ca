# Test Harness Specification: OSS-120B v3 Hardening Validation

## Purpose
Validate that v3 hardening fixes prevent the three documented failure modes in `bugs_120b.md`.

## Test Cases

### TC1: Truncated Content Handling
**Input:** Query that triggers truncated Tavily results (long-form content like documentation pages)
**Expected Behavior:**
- Source marked as `[1 - Partial]` in citations
- No recursive fetch attempts
- Prioritizes complete sources if available
- Outputs warning: "Answer based on incomplete data" if only partials exist

**Validation:**
- [ ] Check citation format contains `[Partial]` marker
- [ ] Verify only ONE Tavily call in tool logs (no loops)
- [ ] Confirm warning message present when appropriate

---

### TC2: Off-Topic Search Results (Relevance Gating)
**Input:** Broad query that historically returns low-relevance results (e.g., "Hugging Face free tier API")
**Expected Behavior:**
- Results with score < 0.15 discarded
- Only high-relevance sources cited
- If zero results pass filter, output: "No confident answer found. Please refine your query..."

**Validation:**
- [ ] All cited Tavily sources have score ≥ 0.15
- [ ] Low-quality results (e.g., Facebook posts, Pinterest) not in final output
- [ ] Graceful zero-result handling (no hallucination)

---

### TC3: Language Contamination Filter
**Input:** Query that triggers non-English results (e.g., product support queries)
**Expected Behavior:**
- If >50% results are non-English, auto-retry with `"site:.com OR site:.org"` appended
- Japanese/regional pages (lg.com/jp) blocked at domain level
- Final citations are English-language only

**Validation:**
- [ ] Confirm domain exclusion blocks lg.com, facebook.com
- [ ] Check for retry query in tool logs if non-English majority detected
- [ ] Verify all final sources are English

---

### TC4: Domain Exclusion Enforcement
**Input:** Generic query that could match spam domains
**Expected Behavior:**
- Tavily call includes: `exclude_domains: ["scribd.com", "pinterest.com", "slideshare.net", "producthunt.com", "facebook.com", "lg.com"]`
- No excluded domains appear in results

**Validation:**
- [ ] Parse Tavily tool call JSON
- [ ] Confirm exclude_domains array is complete
- [ ] Verify no excluded URLs in citations

---

## Test Execution Protocol

1. **Environment:** Deploy v3 prompt to Cerebras OSS-120B endpoint
2. **Method:** Manual query submission + automated log parsing
3. **Success Criteria:** All 4 test cases pass validation checklist
4. **Regression Check:** Re-run original `bugs_120b.md` examples to confirm fixes

## Logging Requirements

For each test case, capture:
- Full tool call JSON (sequential_thinking, tavily, exa, perplexity)
- Tavily result scores and URLs
- Final citations in model output
- Any error messages or warnings

## Failure Escalation

If any test case fails:
1. Document exact failure mode in `bugs_120b.md`
2. Update `adr.md` with new constraint
3. Revise prompt to v3.1
4. Re-run full test suite
