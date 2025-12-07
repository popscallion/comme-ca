# OSS-120B Bug Tracker

**Status:** ✅ All documented bugs resolved in v3 (2025-12-07)

## Resolved Issues

### 1. Truncated Content Handling
**Status:** ✅ Fixed in v3
**Solution:** Added Truncation Protocol (research-cerebras120b.md lines 52-57)
- Sources marked as `[Partial]` in citations
- No recursive fetch (prevents loops)
- Explicit warning when using incomplete data

### 2. Off-Topic Search Results
**Status:** ✅ Fixed in v3
**Solution:** Added Result Quality Gating (research-cerebras120b.md lines 45-50)
- Hard relevance threshold: score < 0.15 → discard
- Language filter auto-retry for non-English majority
- Graceful zero-result handling

### 3. Language/Domain Contamination
**Status:** ✅ Fixed in v3
**Solution:** Expanded domain exclusions (research-cerebras120b.md lines 41-42)
- Added: `facebook.com`, `lg.com` to block list
- Prevents Japanese support pages, social media spam

---

## Test Coverage
See `test-harness-spec.md` for validation protocol.

## Reopening Policy
If any of these bugs resurface:
1. Document new example in this file
2. Update test harness with regression case
3. Increment prompt version (v3 → v3.1)
4. Update ADR with new constraint

---

**Historical Examples (Pre-v3):**
```
[Archived bug examples from original bugs_120b.md - kept for reference]
[Truncated Cerebras pricing page, off-topic Hugging Face results, Japanese LG page]
```
