<!--
@id: drift-report
@version: 1.0.0
@model: gemini-2.0-flash
-->

# Drift Report

**Date:** 2025-12-22
**Status:** 🟡 DRIFT DETECTED

## Executive Summary
The repository is generally well-aligned with its steering documents (`README.md`, `AGENTS.md`, `DESIGN.md`). However, a **significant implementation gap** exists regarding the "Bootstrap Hardening" requirements.

## 1. Critical Implementation Gaps

### 🔴 Bootstrap Hardening (REQUIREMENTS.md vs bin/install)
**Documented Requirement:** `REQUIREMENTS.md` (Section F) explicitly mandates:
1.  **Paranoid Safety Check:** Verify `~/.local/share/chezmoi` remote URL before action.
2.  **Secret Bootstrap:** Interactive prompt for `age` private keys if missing.
3.  **Config Stability:** Specific `chezmoi.toml` generation logic.

**Actual State:** `bin/install` is a standard git cloning script. It contains **none** of this logic. It focuses solely on cloning `comme-ca` and setting up shell aliases.
**Impact:** The installer is less safe/robust than specified for users with dotfiles managed by chezmoi.

### 🟡 Goose Support (README.md vs bin/install)
**Documented:** `README.md` lists Goose as a supported engine. `mise.md` shows examples of running via Goose.
**Actual State:** `bin/install` automates setup for `claude` (`setup:claude`) and `gemini` (`setup:gemini`), but offers **no automated setup** for Goose.
**Impact:** Goose users have a higher friction setup experience (manual configuration required).

## 2. Minor Inconsistencies

### ⚪ Role Nomenclature (AGENTS.md)
**Documented:** `AGENTS.md` lists `Pipe (cca)` as a "Standard Role" alongside `Mise`, `Menu`, etc.
**Actual State:** `Pipe` is a distinct architectural component (CLI wrapper + `prompts/pipe/` templates) rather than a "Role" prompt in `prompts/roles/`.
**Impact:** Negligible. Conceptual abstraction holds up.

## 3. Verified Alignments (Green)

*   ✅ **Architecture:** Directory structure (`prompts/`, `scaffolds/`, `bin/`) matches `DESIGN.md` and `README.md`.
*   ✅ **Naming Conventions:** `specs/` follows the `feature-[slug]` and `bug-[slug]` pattern strictly.
*   ✅ **Search Agent:** The `cca search` implementation in `bin/cca` matches the documented capabilities.
*   ✅ **Versioning:** Protocol version `1.2.0` is consistent across core docs.

## Recommendations

1.  **Implement Bootstrap Hardening:** Update `bin/install` to include the missing checks defined in `REQUIREMENTS.md` Section F, OR move these requirements to a separate `dotfiles-installer` script if `comme-ca` is intended to be decoupled from dotfiles management.
2.  **Clarify Goose Support:** Add a `setup:goose` command to `bin/cca` (if feasible) or explicitly mark Goose setup as "Manual" in `README.md`.
