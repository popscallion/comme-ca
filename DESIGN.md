<!--
@id: design
@version: 1.0.0
@model: gemini-2.0-flash
-->
# DESIGN

## System Philosophy

`comme-ca` operates on a strict "Discovery First" and "Standardized Epistemology" basis. This extends to the file system structure itself.

## Naming Conventions (Strict)

To ensure machine-readability and reduce agent ambiguity:

### 1. Root Level
- **Meta-Documents (ALL CAPS):**
  - `README.md`, `LICENSE`, `AGENTS.md`
  - `REQUIREMENTS.md` (Constraints)
  - `DESIGN.md` (Architecture)
- **Special Files (Underscore + Caps):**
  - `_ENTRYPOINT.md` (Dashboard/Status)
- **Special Directories (Underscore + Caps):**
  - `_INBOX/` (Intake buffer)
  - `_ARCHIVE/` (Specs only)

### 2. Specification Directory (`specs/`)
- **Flat Structure:** Minimize nesting.
- **Prefixes Required:**
  - Features: `feature-[slug]/` (Directory)
  - Bugs: `bug-[slug].md` (Single File) OR `bug-[slug]/` (Directory if complex)
- **Feature Structure:**
  - `specs/feature-x/_ENTRYPOINT.md`
  - `specs/feature-x/REQUIREMENTS.md`
  - `specs/feature-x/DESIGN.md`
  - `specs/feature-x/_RAW/` (For chat logs, context)

### 3. General Rules
- **No inventions.** Use descriptive names.
- **Underscores reserved** for the special files listed above.
- **One special file per level.** (e.g., only one `_ENTRYPOINT.md` in root).

## Architecture

(See README.md for directory tree)
