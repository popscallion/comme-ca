<!--
@id: sync-strategy
@version: 1.0.0
@model: gemini-3-pro-preview
-->
# Ecosystem Synchronization Strategy

**Date:** December 15, 2025
**Context:** Defining the relationship between the Lab, the Distro, and the Consumers (Larval/Chezmoi).

## 1. The Ecosystem Topology

We operate a hub-and-spoke model where intelligence flows downstream from research to production to consumption.

| Tier | Repository | Visibility | Role |
| :--- | :--- | :--- | :--- |
| **Tier 0: Lab** | `comment-dit-on` | **Private** (Future: Public) | **The Source of Intelligence.** Research ground for prompts (`haiku`, `search-agent`). "Alpha" stability. |
| **Tier 1: Distro** | `comme-ca` | **Public** (Target) | **The Operating System.** Stable prompts, CLI tools (`cca`), and standard roles (`mise`, `menu`). "LTS" stability. |
| **Tier 2: Consumer** | `larval-incubator` | **Private** (Maybe Template) | **The Workbench.** Uses `comme-ca` tools to build projects. Contains personal ideas. |
| **Tier 2: Consumer** | `dotfiles` (chezmoi) | **Private** (Maybe Template) | **The Configuration.** Uses `comme-ca` to manage system state. Contains secrets/keys. |

---

## 2. Synchronization Flows

### A. Lab-to-Distro (The "Release" Flow)
*   **Direction:** `comment-dit-on` -> `comme-ca`
*   **Mechanism:** `cca publish` (Planned).
*   **Trigger:** When a prompt (e.g., "Search Agent") is proven stable in the Lab.
*   **Constraint:** Distro must NEVER contain private context or secrets. It must be generic enough for public consumption.

### B. Distro-to-Consumer (The "Update" Flow)
*   **Direction:** `comme-ca` -> `larval-incubator` / `dotfiles`
*   **Mechanism:** Inheritance (Symlinks/Aliases).
    *   Consumers do NOT copy prompt files.
    *   Consumers use `AGENTS.md` to reference the generic roles installed by `comme-ca` in `~/dev/comme-ca`.
*   **Trigger:** `cca update` (pulls latest `comme-ca` main).
*   **Compliance:** Consumers verify compatibility via the `@protocol` version header in their `AGENTS.md`.

### C. Consumer-to-Template (The "Demonstrator" Flow)
*   **Direction:** `larval-incubator` -> `larval-template` (Public)
*   **Mechanism:** Filtering/Sanitization.
*   **Use Case:** Showing the *structure* of the incubator (bits/atoms/signs) without exposing the *content* (specific projects).
*   **Constraint:** This is a manual or scripted "Export" process, not a continuous sync.

---

## 3. Assumptions & Constraints

1.  **Local Pathing:** All repos are assumed to live in `~/Dev/`.
    *   Tools may use relative paths (`../comme-ca`) for cross-repo operations during development.
2.  **Shared Binary:** The `cca` binary (from `comme-ca`) is the universal interface. It is added to `$PATH` and used by all Consumers.
3.  **Strict Separation:**
    *   **Logic** lives in Distro (`comme-ca`).
    *   **Data/Context** lives in Consumers (`larval`, `dotfiles`).
    *   *Never* put project-specific logic in the Distro.
    *   *Never* put generic logic in the Consumer (unless it's a specific override).

## 4. Operational Directives

*   **When creating a new prompt:** Start in **Lab** (`comment-dit-on`).
*   **When stabilizing a prompt:** Move to **Distro** (`comme-ca`).
*   **When fixing a bug in `cca`:** Fix in **Distro**.
*   **When bootstrapping a new idea:** Start in **Larval Incubator**.

---
**Status:** Adopted.
**Maintained by:** `comme-ca` core team.
