<!--
@id: feature-bootstrap-hardening-requirements
@version: 1.0.0
@model: gemini-2.0-flash
-->

# REQUIREMENTS: Bootstrap Hardening

## 1. Problem Statement
The current installer (`bin/install`) lacks sufficient safeguards for handling existing dotfile configurations and sensitive secrets (Age keys) when integrating with `chezmoi`. This creates risks of accidental overwrites and interactive hangups in agentic workflows.

## 2. Requirements

### F. Bootstrap Hardening (Addendum)
**Refined Requirements for `bin/install`:**
To prevent interactive hangups and ensure safety in agentic workflows:

1.  **Paranoid Safety Check:**
    - Before cloning or applying, check if `~/.local/share/chezmoi` exists.
    - If it exists and is a git repo, verify the remote URL.
    - If the remote does not match the target repo, **HALT** with a fatal error. Do not attempt to overwrite.

2.  **Interactive Secret Bootstrap:**
    - If `~/.config/chezmoi/key.txt` is missing, the script MUST pause and ask the user to paste the `age` private key (with hidden input).
    - It must then write this key to the correct location with `chmod 600`.
    - If no key is provided, it should exit gracefully or fall back to a "public-only" mode if supported.

3.  **Config Stability:**
    - The installer should favor generating a `chezmoi.toml` that delegates volatile data to `.chezmoidata.toml` to avoid circular overwrite prompts during the first apply.

## 3. Scope
*   Target Script: `bin/install`
*   Related Tools: `chezmoi`, `age`

## 4. Non-Functional Requirements
*   **Safety:** Zero data loss. Never overwrite without explicit confirmation or safety check.
*   **Idempotency:** Re-running the installer should be safe and non-destructive.
*   **Clarity:** Error messages must be actionable.
