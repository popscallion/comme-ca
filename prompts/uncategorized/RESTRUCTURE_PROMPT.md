# Repository Restructuring and Synthesis Task

## Mission
You are tasked with analyzing two prompt development repositories, synthesizing their best ideas, and executing a restructuring plan to consolidate them into a single, well-organized prompt development repository called "comment-dit-on".

---

## CRITICAL CONSTRAINTS - Read First

### Features to EXCLUDE from Integration
The following features from standard-answerer-agent should **NOT** be adopted:
- ❌ **Phase 3 (Actionable Handoff)** - We only need Phase 1 and Phase 2
- ❌ **Ultrathink Mode** - Deep reasoning triggers not needed
- ❌ **y/n/a pattern** - We use y/n/i instead (see below)
- ❌ Any other enhancements beyond the core two-phase workflow

### Features to PRESERVE from comme-ca
The following must be maintained:
- ✅ **v3 Hardening** - All quality gates, domain filtering, truncation protocol
- ✅ **Two-phase state machine** - Phase 1 (no tools) → Phase 2 (search-backed)
- ✅ **Test harness** - Validation suite and bug tracking
- ✅ **ADR pattern** - Architecture decision records

### New Requirement: Questionnaire Trigger Update
**Change diagnostic questionnaire activation:**
- **OLD:** User types "test" to trigger diagnostic questionnaire
- **NEW:** User types "**?**" or "**i**" (for "interview") to trigger questionnaire
- **Format:** Options should be displayed as "**y/n/i**" (not y/n/? - hard to read)
  - `y` = search and verify (Phase 2)
  - `n` = stop here
  - `i` = launch diagnostic questionnaire (aliases to "?")

**Example output:**
```
I haven't searched yet. Would you like me to:
A) Look this up? (y/n/i)
• y = search and verify
• n = stop here
• i = interview mode (diagnostic questionnaire)
```

---

## Phase 1: Deep Analysis & Discovery

### Step 1: Inspect Source Repository (standard-answerer-agent)
**Location:** `~/dev/standard-answerer-agent`

**Read ALL of the following files thoroughly:**
1. `README.md` - Understand the three-phase workflow concept
2. `prompt.md` - The actual system prompt implementation
3. `IMPLEMENTATION.md` - Implementation details and architecture
4. `QUICKSTART.md` - Usage patterns and examples
5. `AGENTS.md` - Agent orchestration patterns
6. `tasks.md` - Outstanding work items
7. `specs/requirements.md` - Original requirements
8. `specs/design.md` - Design decisions
9. `specs/ULTRATHINK_SPEC.md` - Deep reasoning trigger mechanism
10. `specs/RECENT_FACTS_TRIGGER_SPEC.md` - Auto-detection of time-sensitive queries
11. `specs/TEST_SPEC.md` - Testing framework
12. `TEST_EXECUTOR_PROMPT.md` - Test execution methodology
13. `TESTING_SUMMARY.md` - Test results and learnings

**Key questions to answer:**
- What is the three-phase workflow? (Phase 1, 2, 3)
- What is "Actionable Handoff" (Phase 3)?
- What is "Ultrathink Mode"?
- What is the "Recent Facts Trigger" mechanism?
- What semantic triggers are defined?
- What testing methodology was used?
- What implementation challenges were encountered?

### Step 2: Inspect Target Repository (comme-ca)
**Location:** `/Users/l/Dev/comme-ca/prompts/uncategorized`

**Read ALL markdown files in this directory, paying special attention to:**
1. `standard_search_agent/research-cerebras120b.md` - Current v3 hardened prompt for OSS-120B
2. `standard_search_agent/research-haiku4-5.md` - Current prompt for Haiku 4.5
3. `standard_search_agent/120b-prd.md` - Product requirements document
4. `standard_search_agent/adr.md` - Architecture decision record
5. `standard_search_agent/test-harness-spec.md` - Testing specification
6. `standard_search_agent/bugs_120b.md` - Bug tracking and resolutions
7. All other markdown files in the uncategorized directory

**Key questions to answer:**
- What is the current state-machine architecture?
- What hardening strategies have been implemented (v3)?
- What quality gates exist?
- What testing methodologies are in place?
- What bugs have been resolved?
- What ideas/patterns exist here that are NOT in standard-answerer-agent?

---

## Phase 2: Comparative Analysis & Synthesis

### Step 3: Identify Unique Concepts
Create a comprehensive comparison table:

| Concept | In standard-answerer-agent? | In comme-ca/uncategorized? | Adopt? | Notes |
|---------|----------------------------|---------------------------|--------|-------|
| Two-phase workflow (Phase 1/2) | ✓ | ✓ | ✅ KEEP | Core architecture |
| Phase 3 (Actionable Handoff) | ✓ | ✗ | ❌ EXCLUDE | Not needed per user |
| Ultrathink Mode | ✓ | ✗ | ❌ EXCLUDE | Not needed per user |
| Recent Facts Trigger | ✓ | ? | ⚠️ EVALUATE | Check if useful for Phase 2 |
| Quality Gating (v3) | ? | ✓ | ✅ KEEP | Critical hardening |
| Truncation Protocol | ? | ✓ | ✅ KEEP | Prevents loops |
| Domain Filtering | ? | ✓ | ✅ KEEP | v3 hardening |
| Test Harness | ? | ✓ | ✅ KEEP | Validation suite |
| ADR Pattern | ? | ✓ | ✅ KEEP | Decision tracking |
| Questionnaire trigger | ✓ | ✓ | ✅ UPDATE | Change "test" → "?/i" |
| ... | ... | ... | ... | Fill in ALL discovered concepts |

### Step 4: Identify Implementation Gaps
**For concepts from standard-answerer-agent:**
- Focus ONLY on concepts that support the two-phase workflow
- IGNORE Phase 3, Ultrathink, y/n/a pattern (per CRITICAL CONSTRAINTS)
- Evaluate if Recent Facts Trigger or similar semantic triggers add value to Phase 1/2
- Document any testing methodologies worth preserving

**For concepts from comme-ca:**
- All v3 hardening must be preserved
- Document how these concepts should be organized in comment-dit-on
- Note any gaps in documentation or testing

---

## Phase 3: Present Synthesis to User

### Step 5: Create Synthesis Report
**Format:**
```markdown
# Prompt Repository Synthesis Report

## Executive Summary
[2-3 paragraphs summarizing findings, noting exclusions per CRITICAL CONSTRAINTS]

## Excluded Features (Per User Requirements)
The following features from standard-answerer-agent are being EXCLUDED:
- Phase 3 (Actionable Handoff)
- Ultrathink Mode
- y/n/a pattern (replaced with y/n/i)

These were reviewed but deemed unnecessary for the current use case.

## Concepts to Adopt from standard-answerer-agent

### 1. [Concept Name] (Value: High/Medium/Low)
**Description:** [What it is - only list if NOT excluded above]
**Current Status:** [Specified but not implemented / Partially implemented / etc.]
**Integration Complexity:** [Easy/Medium/Hard]
**Recommendation:** [How to integrate into comme-ca prompts]

**NOTE:** Do NOT list Phase 3, Ultrathink, or y/n/a here

## Concepts to Preserve from comme-ca/uncategorized

### 1. [Concept Name] (Value: High/Medium/Low - default HIGH for v3 hardening)
**Description:** [What it is]
**Why Preserve:** [Importance to current architecture]
**Migration Strategy:** [How to move to comment-dit-on]

## Required Changes

### 1. Questionnaire Trigger Update
**Change:** "test" → "?" or "i" (interview mode)
**Affected Files:** [List prompts that need updating]
**Implementation:** [Specific text changes needed]

## Synthesis Recommendations

### Recommended Approach: Selective Migration with Preservation
- **PRESERVE:** All v3 hardening from comme-ca (quality gates, domain filtering, truncation protocol)
- **PRESERVE:** Test harness and ADR pattern from comme-ca
- **ADOPT:** Testing methodology from standard-answerer-agent (if superior)
- **ADOPT:** Documentation structure from standard-answerer-agent (if clearer)
- **UPDATE:** Questionnaire triggers to use "?/i" instead of "test"
- **EXCLUDE:** Phase 3, Ultrathink, y/n/a pattern

**Pros:** Maintains working v3 prompts while improving organization/docs
**Cons:** [Any potential issues]

## Questions for User Decision
1. Should we adopt "Recent Facts Trigger" semantic detection? (auto-skip Phase 1 for time-sensitive queries)
2. [Other questions about non-excluded features]
3. [Documentation structure preferences]
[etc. - no questions about excluded features]
```

### Step 6: Present to User & Get Preferences
**DO NOT PROCEED until user reviews synthesis and provides guidance on:**
- Which unique concepts to adopt
- Which concepts to discard
- Priority order for implementation
- Directory structure preferences
- Documentation strategy

---

## Phase 4: Execute Restructuring (ONLY after user approval)

### Step 7: Rename Repository
```bash
cd ~/dev
mv standard-answerer-agent comment-dit-on
```

### Step 8: Restructure Directory Layout
**Proposed structure (adjust based on user feedback):**
```
comment-dit-on/
├── README.md                      # Repository overview
├── prompts/
│   ├── search_agents/
│   │   ├── cerebras-120b-v3.md   # From comme-ca (with "?/i" triggers)
│   │   ├── haiku45-v3.md          # From comme-ca (with "?/i" triggers)
│   │   ├── prd.md                 # Consolidated PRD (two-phase only)
│   │   └── examples/              # Test cases
│   ├── utilities/
│   │   ├── metaprompt.md         # From comme-ca
│   │   ├── compare.md            # From comme-ca
│   │   ├── extract.md            # From comme-ca
│   │   └── summarize.md          # From comme-ca
│   └── experimental/
│       └── [any draft prompts - archive Phase 3/Ultrathink if present]
├── specs/
│   ├── search_agent/
│   │   ├── adr.md                # Architecture decisions
│   │   ├── test-harness.md       # Testing spec
│   │   ├── bugs.md               # Bug tracking
│   │   └── [only non-excluded specs from standard-answerer-agent]
│   └── [other spec categories]
├── archive/                       # Excluded features for reference
│   ├── phase-3-spec.md           # Actionable Handoff (not adopted)
│   └── ultrathink-spec.md        # Deep reasoning (not adopted)
├── docs/
│   ├── quickstart.md
│   ├── implementation-guide.md
│   └── testing-guide.md
└── tools/
    └── [any testing or validation scripts]
```

### Step 9: Migrate Content & Update Triggers
**For each file in comme-ca/prompts/uncategorized:**
1. Determine destination in new structure
2. Check for conflicts with existing standard-answerer-agent files
3. If conflict exists:
   - Compare content
   - Merge if both have value (excluding Phase 3/Ultrathink)
   - Choose newer/better version if duplicate
   - Document decision in migration log
4. **Update questionnaire triggers:**
   - Find all instances of `(y/n/a)` or `"test"` for questionnaire
   - Replace with `(y/n/i)` pattern
   - Update option descriptions to match new format
   - Document changes in migration log
5. Move or copy file
6. Update any internal references/links

### Step 10: Create Migration Log
Document all moves, merges, and decisions in `MIGRATION_LOG.md`

### Step 11: Update Documentation
- Update README.md with new structure
- Update all file paths in documentation
- Create index of prompts with descriptions
- Update CLAUDE.md and AGENTS.md if needed

### Step 12: Validate
- Check all internal links work
- Verify no duplicate content
- Run any existing tests
- Create git commit with comprehensive message

---

## Critical Constraints

1. **DO NOT execute Phase 4 without explicit user approval**
2. **Preserve all git history** - use `git mv` for renames when possible
3. **Do not delete any content** without user confirmation
4. **Document all decisions** in migration log
5. **Ask questions** when ambiguity exists

---

## Success Criteria

✅ All files from standard-answerer-agent analyzed and documented
✅ All files from comme-ca/uncategorized analyzed and documented
✅ Comprehensive synthesis report presented to user
✅ User has provided clear guidance on preferences
✅ Repository restructured according to approved plan
✅ All content accessible in new structure
✅ Documentation updated and accurate
✅ Git history preserved where possible
✅ Migration log complete and detailed

---

## Output Requirements

### At End of Phase 2 (Before Any Restructuring)
**Deliver:**
1. Synthesis report (markdown format)
2. Concept comparison table
3. Specific questions for user decision
4. Proposed directory structure (for user approval)

**Wait for user to:**
- Review synthesis
- Answer questions
- Approve structure
- Provide priorities

### At End of Phase 4 (After Restructuring)
**Deliver:**
1. Migration log
2. Updated README for comment-dit-on
3. Summary of changes
4. Git commit message (for user to review before push)

---

## Special Instructions

### When Reading Files
- Note the **purpose** and **key concepts** of each file
- Identify **dependencies** between files
- Look for **version information** or timestamps
- Check for **TODO/FIXME** comments indicating incomplete work

### When Comparing
- Don't just look for exact duplicates
- Identify **conceptual overlap** even with different implementations
- Note **evolutionary improvements** (e.g., v2 → v3)
- Recognize **complementary** vs. **competing** approaches

### When Presenting to User
- Use **tables** for comparisons
- Provide **concrete examples** of concepts
- Highlight **high-impact** decisions early
- Be honest about **unknowns** or **risks**

---

## FINAL REMINDERS - Read Before Starting

### What to EXCLUDE (Do Not Adopt)
When reading standard-answerer-agent files, you will encounter these features. **DO NOT** recommend adopting them:
- ❌ Phase 3 / Actionable Handoff / y/n/a pattern
- ❌ Ultrathink Mode / Deep reasoning semantic triggers
- ❌ Any three-phase workflow concepts

Archive these in `archive/` folder for reference only.

### What to PRESERVE (Must Keep)
From comme-ca, these are **MANDATORY** to preserve:
- ✅ All v3 hardening (quality gates, domain filtering, truncation protocol)
- ✅ Two-phase state machine (Phase 1 → Phase 2)
- ✅ Test harness and ADR pattern
- ✅ Bug tracking and resolution documentation

### What to UPDATE (Required Change)
All prompts with diagnostic questionnaire features must be updated:
- **OLD:** `"test"` trigger, `(y/n/a)` options
- **NEW:** `"?"` or `"i"` trigger, `(y/n/i)` options
- Example: `"Would you like me to: (y/n/i) • y = search • n = stop • i = interview mode"`

---

## Begin Your Analysis

Start with Phase 1, Step 1: Read all files from `~/dev/standard-answerer-agent`.

**As you read, actively note which features are in the EXCLUDE list above.**

Take detailed notes for each file:
- Main purpose
- Key concepts/ideas
- Dependencies on other files
- Notable implementation details
- **Whether it relates to excluded features (Phase 3/Ultrathink)**

Once you complete Step 1, proceed to Step 2 and repeat the process for `/Users/l/Dev/comme-ca/prompts/uncategorized`.

After completing both Steps 1 and 2, move to Phase 2 and create your comparative analysis.

**Remember:**
1. Do NOT recommend excluded features in your synthesis
2. Do NOT execute any restructuring (Phase 4) until the user has reviewed your synthesis and provided explicit approval
3. DO clearly mark excluded features in your analysis so user understands what was reviewed but not adopted
