<!--
@id: feature-bootstrap-hardening-design
@version: 1.0.0
@model: gemini-2.0-flash
-->

# DESIGN: Bootstrap Hardening

## 1. Architecture
The hardening logic will be implemented as functions within `bin/install`.

## 2. Data Flow
1.  **Check Phase:**
    *   Inspect `~/.local/share/chezmoi`
    *   Inspect `~/.config/chezmoi/key.txt`
2.  **Prompt Phase:**
    *   If keys missing, prompt user (masked input).
3.  **Action Phase:**
    *   Write keys (if provided).
    *   Generate/Update `chezmoi.toml`.
    *   Clone/Apply dotfiles.

## 3. Key Functions
*   `check_chezmoi_safety()`: verifying git remotes.
*   `bootstrap_secrets()`: handling age key input.
*   `configure_chezmoi()`: generating split config files.

## 4. Dependencies
*   `git`
*   `chezmoi` (must be installed or installed by script)
*   `age` (optional, for key handling)
