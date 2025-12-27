<!--
@id: feature-bootstrap-hardening-entrypoint
@version: 1.0.0
@model: gemini-2.0-flash
-->

# Iteration Dashboard: Bootstrap Hardening

| Status | Description | Owner |
| :--- | :--- | :--- |
| **Pending** | Spec created, awaiting implementation | Gemini |

## Tasks
- [ ] Implement `check_chezmoi_safety` in `bin/install`
- [ ] Implement `bootstrap_secrets` in `bin/install`
- [ ] Implement `configure_chezmoi` logic
- [ ] Verify idempotency
- [ ] Verify safety checks (mock existing bad state)

## Context
Refactoring `bin/install` to meet Section F requirements from root `REQUIREMENTS.md`.
