Sparked by work done in ~/dev/fahn-lai-bun on 1/1/2026
***

# Complementary Instruction Patterns for Agent Adherence

## The Problem You're Facing

Your agents work great with React/standard library stuff, but struggle with non-standard libraries (Svelte, custom frameworks, domain-specific tools). The issue is that **AGENTS.md alone is not sufficient for libraries outside the LLM's training data**.

## Why AGENTS.md Pointing to Docs Fails

**Current Setup:**
```
AGENTS.md → docs/TESTING-GUARDRAILS.md
         → docs/library-patterns.md
         → docs/agents.md
```

**The Problem:**
- Claude/OpenCode reads AGENTS.md
- AGENTS.md says "see docs/library-patterns.md"
- Agent reads library-patterns.md
- Agent sees guidance like "Use Svelte Runes correctly"
- But agent's training data has minimal Svelte examples
- **Result:** Agent invents code that "sounds right" but violates the actual patterns

## The Solution: The "Five-Layer Instruction Stack"

This is a proven pattern used by 2,500+ repos (per GitHub's analysis). It combines:
1. **AGENTS.md** (The Hub)
2. **Inline Examples** (The Evidence)
3. **Library/Tool-Specific MCP** (The Expert)
4. **Pre-Commit Validation** (The Gatekeeper)
5. **Hierarchical Nested Agents.md** (The Local Context)

***

## Layer 1: Restructure AGENTS.md with "Do/Don't" Bias

Your current AGENTS.md should be 80% concrete examples, 20% rules.

**Current (Fails):**
```markdown
# AGENTS.md

## Svelte Patterns
Follow the patterns in docs/library-patterns.md
```

**Fixed (Works):**
```markdown
# AGENTS.md

## Svelte Pattern: State and Derived Values

### ✅ DO - Correct Pattern
```svelte
<script>
  let count = $state(0);
  const doubled = $derived(count * 2);
</script>
```

### ❌ DON'T - Reactive Trap
```svelte
<script>
  let count = $state(0);
  let doubled = $state(count * 2);  // ❌ Creates stale state
</script>
```

## Svelte Pattern: Keyboard Navigation

### ✅ DO - Guard Pattern
```ts
function handleKeyDown(event: KeyboardEvent) {
  if (viewState?.current !== 'side') return;  // ← Guard FIRST
  if (event.key === 'ArrowLeft') { /* ... */ }
}
```

### ❌ DON'T - Naked Handlers
```ts
function handleKeyDown(event: KeyboardEvent) {
  if (event.key === 'ArrowLeft') { /* ... */ }  // ❌ Fires in all views
}
```

## Library Constraint: @acme/ui v3

### ✅ DO
- Use emotion `css={{}}` prop format (v3 standard)
- Use MUI v3 imports: `import Button from '@mui/material/Button'`
- Import tokens from `DynamicStyles.tsx`

### ❌ DON'T
- Do not use styled-components (legacy)
- Do not hard-code colors
- Do not import from '@mui/core' (old API)

See concrete examples in `/examples/buttons.svelte` and `/examples/forms.svelte`
```

**Key Changes:**
- Side-by-side DO/DON'T examples for every pattern
- File paths to real working examples
- Concrete library constraints (v3, imports, etc.)
- Enough detail that agent doesn't have to guess

***

## Layer 2: Create `/examples` Directory with Real Working Code

Agents learn by imitation. Put your best, most canonical examples in a dedicated folder.

```
/examples
  ├── buttons.svelte         # "How to use @acme/ui v3 buttons"
  ├── forms.svelte           # "How to structure forms"
  ├── keyboard-nav.ts        # "How to implement keyboard navigation"
  ├── state-management.svelte # "How to use $state/$derived correctly"
  └── api-integration.ts     # "How to use app/api/client.ts"
```

**Example: `/examples/state-management.svelte`**
```svelte
<!-- CORRECT: State + Derived Pattern -->
<script>
  import { debounce } from 'lodash-es';
  
  let searchQuery = $state('');
  let isLoading = $state(false);
  
  // ✅ Derived is reactive to searchQuery changes
  const results = $derived.by(async () => {
    if (!searchQuery) return [];
    isLoading = true;
    const data = await fetch(`/api/search?q=${searchQuery}`);
    isLoading = false;
    return data;
  });
</script>

<!-- Key pattern: isLoading tracks async, results derives from searchQuery -->
```

**In AGENTS.md, reference this:**
```markdown
### State Management Pattern

For state + derived async patterns, see `/examples/state-management.svelte` for the canonical approach.
Key concepts:
- Derived declarations are NOT hoisted — define $state first
- Use $derived.by() for async operations
- Track loading separately from data
```

When agent reads this, it:
1. Reads the rule in AGENTS.md
2. Finds the file path
3. Opens the real code
4. Can now imitate it exactly

***

## Layer 3: Create Tool-Specific Instruction Files

For non-standard libraries, create a dedicated instruction file that agents can read.

**Pattern:**
```
/docs
  ├── AGENTS.md               # Root instructions
  ├── TESTING-GUARDRAILS.md   # QA rules
  ├── library-patterns.md     # General patterns
  └── SVELTE-RUNES.md         # ← NEW: Svelte-specific
  └── FRAMEWORK-APIS.md       # ← NEW: Your custom APIs
```

**Example: `/docs/SVELTE-RUNES.md`**
```markdown
# Svelte Runes: The Complete Pattern Guide

## CRITICAL: $state vs let vs const

| Use Case | Pattern | Why |
|----------|---------|-----|
| **Reactive data** | `let x = $state(0)` | Component tracks changes |
| **Computed from state** | `const y = $derived(x * 2)` | Recomputes when x changes |
| **Refs (DOM nodes)** | `let containerRef = $state<HTMLDiv \| null>(null)` | Stored in state for binding |
| **Constants** | `const MAX = 100` | No reactivity needed |
| **Props** | `let { items } = $props()` | Declared in script, not $state |

## Anti-Pattern: Storing Derived Values in State

```svelte
❌ WRONG:
let count = $state(10);
let doubled = $state(count * 2);  // Stale! Doesn't update when count changes

✅ RIGHT:
let count = $state(10);
const doubled = $derived(count * 2);  // Always in sync
```

## Anti-Pattern: $state in Template Expressions

```svelte
❌ WRONG:
<script>
  let inputRef = $state<HTMLInputElement | null>(null);
</script>

<input bind:value={inputRef} />  // Can't mutate $state in template

✅ RIGHT:
<script>
  let inputRef: HTMLInputElement | null = null;
</script>

<input bind:this={inputRef} />
```

## Keyboard Events: The Guard Pattern

Multiple components can listen to keyboard events. They MUST guard:

```ts
function handleKeyDown(event: KeyboardEvent) {
  // ✅ GUARD FIRST: Is this event for me?
  if (viewState?.current !== 'timeline') return;
  
  // Only then, handle the event
  switch (event.key) {
    case 'ArrowLeft': navigatePrev(); break;
    case 'ArrowRight': navigateNext(); break;
  }
}
```

See: `/src/components/TimelineController.svelte` for full example.
```

**Agent reads this file and now has:**
- Explicit DO/DON'T
- Real code examples
- File paths to reference
- Table for decision-making

***

## Layer 4: "Library Context" Frontmatter in AGENTS.md

Add a structured frontmatter that tools can parse:

```yaml
---
languages: [typescript, svelte]
frameworks: [sveltekit, vite]
ui_library:
  name: "@acme/ui"
  version: "v3"
  import_pattern: "import Button from '@acme/ui/Button'"
  css_pattern: "emotion css={{}} prop"
state_management:
  library: "svelte-runes"
  key_concepts:
    - "$state for reactive data"
    - "$derived for computed values"
    - "guard keyboard handlers"
  anti_patterns:
    - "Storing derived values in $state"
    - "$state in template expressions"
api_client: "app/api/client.ts"
test_runner: "vitest"
---

# AGENTS.md

...rest of instructions...
```

Agents that support YAML frontmatter (Claude, OpenCode) will parse this and have structured context about your tech stack.

***

## Layer 5: Hierarchical Nested AGENTS.md for Complex Projects

If you have Svelte components in `/src/components` and they follow different patterns than `/src/api`, use nested files:

```
/src
  ├── AGENTS.md               # General rules
  ├── components/
  │   ├── AGENTS.md           # ← Component-specific rules
  │   ├── Button.svelte
  │   └── Form.svelte
  ├── api/
  │   ├── AGENTS.md           # ← API-specific rules
  │   ├── client.ts
  │   └── handlers.ts
  └── utils/
      └── AGENTS.md           # ← Utility-specific rules
```

**In `/src/components/AGENTS.md`:**
```markdown
# Component Development Rules

**Always:**
- Guard keyboard handlers with view state check
- Use $derived for computed values
- Import UI components from @acme/ui
- See SVELTE-RUNES.md for state patterns

**Never:**
- Store derived values in $state
- Use class components
- Hard-code colors (use DynamicStyles.tsx)

For full patterns, see `/docs/SVELTE-RUNES.md`
```

**In `/src/api/AGENTS.md`:**
```markdown
# API Layer Rules

**Always:**
- Use app/api/client.ts for HTTP requests
- Type responses with TypeScript
- Handle errors explicitly
- See API_INTEGRATION.md for patterns

**Never:**
- Use fetch() directly in components
- Hard-code URLs
- Skip error handling
```

When an agent edits `/src/components/Button.svelte`, it reads:
1. `/src/components/AGENTS.md` (most specific)
2. `/src/AGENTS.md` (fallback)
3. `/AGENTS.md` (root level)

This solves your problem with non-standard libraries: **Each domain gets its own instruction set.**

***

## Layer 6: Pre-Commit Validation (Already Discussed)

Your `qa-sentinel.py` hook should reference these instruction files:

```python
# scripts/qa-sentinel.py
def get_context_for_file(filepath):
    # Determine which AGENTS.md applies to this file
    if 'components' in filepath:
        context = read_file('src/components/AGENTS.md')
    elif 'api' in filepath:
        context = read_file('src/api/AGENTS.md')
    else:
        context = read_file('AGENTS.md')
    
    # Add library-specific docs
    context += read_file('docs/SVELTE-RUNES.md')
    return context

def main():
    diff = subprocess.check_output(['git', 'diff', '--staged']).decode()
    context = get_context_for_file(diff_file)
    
    # Send to Claude with full context
    response = claude_api.messages.create(
        system=f"You are a code reviewer. Follow these standards:\n{context}",
        messages=[{"role": "user", "content": f"Review this diff:\n{diff}"}]
    )
```

The sentinel doesn't just check linting—it checks **adherence to your instruction stack**.

***

## Summary: The Five-Layer Stack for Your Project

1. **AGENTS.md (Hub)** — Rules + DO/DON'T examples for every pattern
2. **`/examples` Directory** — Real working code to imitate
3. **Tool-Specific Docs** — `/docs/SVELTE-RUNES.md`, `/docs/FRAMEWORK-APIS.md`
4. **Structured Frontmatter** — YAML metadata for tech stack
5. **Hierarchical AGENTS.md** — Nested instructions for each domain

When an agent (Claude/OpenCode/Gemini) works on your code:
1. Reads closest AGENTS.md
2. Follows DO/DON'T examples
3. References `/examples` for canonical patterns
4. Checks `/docs/SVELTE-RUNES.md` for library-specific rules
5. Runs pre-commit validation that enforces everything

**Result:** Exact same behavior across all agents.

Sources
[1] TESTING-GUARDRAILS.md https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/140617749/9918e18d-fce9-4211-ad99-4b4402f93679/TESTING-GUARDRAILS.md
[2] library-patterns.md https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/140617749/a6179b3f-392e-4300-8d3d-eb62d7720609/library-patterns.md
[3] AGENTS.md https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/140617749/03f489f3-0e94-4604-81dd-89a9c9427f87/AGENTS.md
