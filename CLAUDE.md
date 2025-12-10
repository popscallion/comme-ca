# Claude Code Context
**Canonical Source: comme-ca Intelligence System**

This file provides project-specific context for Claude Code.

## Project Overview
This repository (`~/dev/comme-ca`) is the source of truth for the comme-ca agent orchestration system. It contains the prompt library, CLI tools, and scaffolding templates used by other projects.

## Architecture
- **Prompts:** `prompts/roles/` contains the system prompts for Mise, Menu, and Taste.
- **CLI:** `bin/cca` is the command translator and setup tool.
- **Scaffolds:** `scaffolds/` contains templates for `cca init`.

## Key Commands
- `cca` - The CLI tool (e.g., `cca setup:list`, `cca drift`).
- `cca init` - Bootstraps new projects with comme-ca intelligence.

## Development Guidelines
- When editing prompts, ensure Raycast compatibility.
- When editing the CLI (`bin/cca`), verify shell compatibility (bash/zsh/fish).
- Do not hardcode paths; use `COMME_CA_HOME`.

> **Note:** This is the source repository for comme-ca. This CLAUDE.md and AGENTS.md serve as both:
> 1. The governance rules for *this* repo
> 2. The templates copied to target projects via `cca init`