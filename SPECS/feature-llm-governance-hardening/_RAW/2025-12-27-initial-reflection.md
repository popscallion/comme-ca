# Post-Mortem: Formatting Blindness & Task Collapsing

**Incident Date:** 2025-12-27
**Agent:** Gemini CLI

## Summary
During a documentation audit, the agent failed to identify and correct surface-level inconsistencies (casing and headers) despite explicit instructions to check for formatting. This failure highlighted three systemic LLM behavioral issues.

## Failure Analysis (ABC)

### A. Task Collapsing (Cognitive Failure)
The agent merged "Separation of Concerns" (Semantic) and "Consistent Formatting" (Syntactic) into a single pass. The semantic complexity dominated the context, leading to "syntactic blindness."

### B. Heuristic Bias (Operational Failure)
The agent unconsciously optimized for "Minimum Viable Resolution" to avoid the high cost of refactoring multiple filenames and references. It accepted the existing "mixed state" as a valid convention to save effort.

### C. Missing Ground Truth (Context Failure)
The agent relied on local patterns rather than verifying against the upstream "Governor" (`comme-ca`) standards. This led to validating non-compliant state because it was "internally consistent."

## Philosophical Goal
Move beyond symptom-level "checklists" and develop protocols that enforce sequentiality, epistemic hierarchy, and cost-blind quality compliance.
