

GPT-OSS-120B Search Orchestrator – Prompt & Behavior Documentation

Overview

This document describes the behavior of a two-phase, multi-turn search orchestrator built on GPT-OSS-120B (Cerebras) that integrates:
	•	Phase 1: Immediate, off-the-top-of-head answers (no tools).
	•	Phase 2: Optional, search-backed answers using:
	•	Tavily – fast, keyword-based web search for concrete facts.
	•	Exa – semantic / research search for approaches, themes, and literature-style queries.

The system supports:
	•	Explicit user consent for web search (yes/no flow).
	•	A “force search” override using a leading or trailing ?.
	•	Fuzzy yes/no parsing (“sure”, “go ahead”, “no thanks”, etc.).
	•	Clear verification in Phase 2 about whether Phase 1 was confirmed or corrected.
	•	Smart routing between Tavily, Exa, or both for complex queries.

⸻

High-Level Interaction Model

Normal Flow (Two-Turn)
	1.	Turn 1 – Phase 1 (no tools)
	•	User asks a question normally (no override).
	•	Model responds immediately from internal knowledge only, labeled as unverified.
	•	Model then asks: “Would you like me to search the web and confirm this with sources? (y/n)”.
	2.	Turn 2 – User Consent
	•	If the user replies with a YES-like message → Model enters Phase 2 and uses Tavily/Exa.
	•	If the user replies NO-like → Model stays in Phase 1-only mode (no tools).
	•	If the user asks another question or says something else → treat that as a new query unless it clearly means “please search now”.

Override Flow (Single-Turn)

The user can force immediate Phase 2 (no Phase 1) by adding a ? override:
	•	After trimming whitespace, if:
	•	the first character is ?, or
	•	the last character is ?
→ The model skips Phase 1 and goes straight to Phase 2 with search.

Examples:
	•	? what are current EU AI regulations → Phase 2 immediately.
	•	what are current EU AI regulations ? → Phase 2 immediately.
	•	What are current EU AI regulations? (no extra spaces) → Phase 2 immediately (trailing ?).

⸻

Phase 1 – Immediate Answer (No Tools)

When it triggers
	•	A “normal” new query (no override ?), first response for that query.

Behavior
	•	No tools permitted in Phase 1.
	•	Uses only internal model knowledge.
	•	Response structure:

### Phase 1 – Immediate Answer (Unverified)
<concise answer based on internal knowledge>

I haven’t searched the web yet. Would you like me to look this up and confirm with sources? (y/n)

Guidelines:
	•	1–5 short paragraphs or a compact bullet list.
	•	Clearly labeled Unverified.
	•	Always ends with the consent question.
	•	No mention of specific tools (“Tavily”, “Exa”)—just “search the web” / “look it up”.

⸻

Consent Handling – Fuzzy Yes/No

YES-like Responses (Trigger Phase 2)

Examples that should be treated as YES:
	•	y, yes, yeah, yep, yup, sure, ok, okay, please, go ahead,
	•	yes please, sure, go ahead, do it, sounds good,
	•	that would be great, please check, can you verify that?, add sources, etc.

When the latest user message is YES-like:
	•	Enter Phase 2 for the previous query.
	•	Use Tavily and/or Exa as needed.
	•	Return a search-backed Phase 2 response.

NO-like Responses (Stay Phase 1-Only)

Examples treated as NO:
	•	n, no, nope, nah, don’t, no thanks,
	•	I’m good, that’s fine, don’t bother, not needed, no need, etc.

When the latest user message is NO-like:
	•	Acknowledge their choice.
	•	Do not call any search tools.
	•	You may refine or clarify using internal knowledge only.

Other Responses

If the latest message is neither clearly YES nor NO:
	•	If it looks like a new question → treat it as a new query and restart the Phase 1 flow.
	•	If it clearly refers to the prior answer and means “now please search”
(e.g. “can you confirm that?”, “now check with sources”), treat it as YES and enter Phase 2.

⸻

Phase 2 – Search-Backed Answer

Phase 2 is responsible for:
	•	Running Tavily/Exa as needed.
	•	Producing a search-backed answer.
	•	Providing a machine-readable JSON with bullets + sources.
	•	Explicitly stating how Phase 1 held up (confirmed vs corrected).

When Phase 2 Triggers
	•	User gave a YES-like response after Phase 1, OR
	•	Original query had override ? (leading or trailing), OR
	•	System explicitly requests a search-backed answer.

Phase 2 Response Structure

Phase 2 responses always look like:

### Phase 2 – Search-Backed Answer
Verification: <one concise sentence about Phase 1 correctness>

- <bullet 1>
- <bullet 2>
...

Sources:
1. <source 1 title> (<source 1 URL>)
2. <source 2 title> (<source 2 URL>)
...

```json
{
  "data": {
    "bullets": [...],
    "sources": [...],
    "render_markdown": "<must exactly match the bullet+Sources markdown above>"
  },
  "error": {
    "code": "NONE",
    "message": ""
  }
}

Verification Line
The verification line is a one-liner before the bullets, clearly stating how Phase 1 fared:
	•	If Phase 1 exists and is fully supported:
Verification: Phase 1 answer is confirmed by search results.
	•	If Phase 1 exists and needs correction / nuance:
Verification: Phase 1 answer requires correction/clarification; see updated details below.
	•	If Phase 1 was skipped via override ?:
Verification: Phase 1 was skipped (override '?'); this answer is fully search-based.

This makes it easy to see whether Phase 1 was right, wrong, or incomplete.

⸻

Tavily vs Exa Routing

Routing happens only in Phase 2 and is internal (not printed). The model chooses between:
	•	tavily_only
	•	exa_only
	•	tavily_plus_exa

When to Use Tavily

Use Tavily for:
	•	Simple, discrete facts:
	•	“What year was the first iPhone released?”
	•	“Who is the current CEO of Microsoft?”
	•	Entity-centric questions:
	•	capitals, currency codes, stock tickers, basic metrics.
	•	Time-sensitive facts:
	•	current company leadership, market caps, recent events.

When to Use Exa

Use Exa for:
	•	Conceptual / research questions:
	•	“What are the main categories of AI alignment research?”
	•	“Summarize key arguments for and against universal basic income.”
	•	Questions about:
	•	approaches, methods, themes, literature, critiques, architectural patterns, etc.

When to Use Both (Tavily + Exa)

Use both for mixed queries needing:
	•	Conceptual overview and concrete facts / timelines / organizations.

Example:

“What are the main approaches to AI alignment and how have they evolved since 2018?”

Routing for this query:
	•	Exa first:
	•	Find main approaches (e.g., RLHF, interpretability, debate, constitutional AI, scalable oversight, etc.).
	•	Identify how literature describes evolution since 2018 (e.g., growth of RLHF, rise of RLAIF, etc.).
	•	Tavily second:
	•	Anchor specific dates, key orgs (OpenAI, Anthropic, DeepMind), and high-impact milestones.
	•	Make sure any “since 2018” claims are backed by real events / publications with dates.

This query is explicitly documented as tavily_plus_exa in the routing rules, so the model should not fall back to Tavily-only.

⸻

Search Limits & Evidence Rules

Query Limits
	•	Per tool: up to 3 queries total.
	•	Per query: up to 5 results.
	•	Stop early once you have enough evidence for 3–6 bullets and ideally ≥2 independent sources per key fact.

Independence & Quality
	•	Independent sources:
	•	Different organizations and different registrable domains (not just subdomains).
	•	Quality tiers:
	•	Tier 1: official / primary sources, standards, original papers, gov / major institutions.
	•	Tier 2: major news outlets, respected publishers, well-cited technical blogs.
	•	Tier 3: forums, Q&A, small blogs → only for gaps or corroboration.
	•	Ignore:
	•	SEO spam, obvious AI-generated filler, and unverifiable paywalled snippets.

Conflicts

If credible sources disagree:
	1.	Run at least one focused follow-up query.
	2.	If disagreement persists:
	•	Add a bullet with kind="consensus_discord" summarizing the different views and (if clear) which is more widely accepted.

⸻

JSON Schema & render_markdown Contract

Phase 2 must return a JSON object with:
	•	data.bullets: 0–6 bullet objects
	•	data.sources: 0–6 source objects
	•	data.render_markdown: a string that must exactly match (byte-for-byte) the bullet + Sources: markdown printed above the JSON.

Bullets

Each bullet object:
	•	text: string, ≤160 characters, ≤18 words, directly answering part of the query.
	•	kind: optional, "fact" or "consensus_discord" (default is fact if omitted).
	•	source_ids: array of IDs (e.g., ["s1","s2"]) referencing supporting sources.

Guidelines:
	•	3–6 bullets on normal success.
	•	Each bullet should be concise and non-overlapping.

Sources

Each source object:
	•	id: string like "s1", "s2".
	•	domain: registrable domain (e.g., "example.org").
	•	title: page/article title.
	•	url: canonical URL (strip obvious tracking params).
	•	published: optional RFC 3339 timestamp (if reliably available).

render_markdown Layout

render_markdown must have this exact structure:

- <bullet 1 text>
- <bullet 2 text>
...

Sources:
1. <source 1 title> (<source 1 URL>)
2. <source 2 title> (<source 2 URL>)
...

Important:
	•	One -  line per bullet, in the same order as data.bullets.
	•	Blank line between the bullets and Sources:.
	•	Numbered lines correspond 1:1, in order, with data.sources.
	•	The final line is the final source line.
	•	The markdown printed in Phase 2 must exactly equal data.render_markdown.

⸻

Failure Modes

Schema Violation

If the model cannot build a valid object:
	•	Phase 2 markdown (after the verification line) is empty.
	•	JSON is exactly:

{"data":{"bullets":[],"sources":[],"render_markdown":""},"error":{"code":"SCHEMA_VIOLATION","message":"<reason>"}}

Insufficient Evidence

If web evidence is too weak or contradictory:
	•	Phase 2 markdown (after verification line) is just:

Sources:

(with a trailing newline).
	•	JSON is exactly:

{"data":{"bullets":[],"sources":[],"render_markdown":"Sources:\n"},"error":{"code":"INSUFFICIENT_EVIDENCE","message":"Insufficient evidence to answer confidently."}}


⸻

Implementation Notes
	•	App-level orchestration:
	•	You enforce “first reply = Phase 1 (no tools)” vs “later reply = Phase 2 (tools allowed)” in your app or agent framework.
	•	The prompt teaches the model how to behave; the environment decides when tools are even available.
	•	Streaming:
	•	In most tool APIs, you can’t stream Phase 1, then pause mid-turn and ask for y/n inside the same turn.
	•	Instead, you implement the Phase 1 and Phase 2 as separate turns, which this documentation and prompt are designed for.
	•	Routing tuning:
	•	You can expand the test set of queries (labeled tavily_only, exa_only, tavily_plus_exa) to evaluate whether GPT-OSS-120B is choosing the right tools.
	•	Especially validate that complex queries like:
“What are the main approaches to AI alignment and how have they evolved since 2018?”
route to Exa + Tavily, not Tavily alone.
