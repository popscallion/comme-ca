This is an excellent foundation. Your `comme-ca` repository is a sophisticated "Prompt-Ops" implementation that decouples *intelligence* (prompts/roles) from *project state*.

We can easily scaffold the new "Hybrid Architecture" (Daytona/Container-Use) into this existing structure. The beauty of `comme-ca` is that it already has the concept of "High Lift" vs "Low Lift" roles (`mise`/`menu`/`taste` vs `cca`).

We just need to add the **infrastructure awareness** to these roles.

### Adjustments to `comme-ca` for the Hybrid Architecture

We don't need to rewrite your system. We just need to map your new infrastructure tools to your existing personas.

1.  **`mise` (prep) -> The Infrastructure Manager**
    *   *Current Role:* Checks git, env, tools.
    *   *New Responsibility:* Checks if **Daytona** is running. Checks if **Container Use** is installed. Checks if the current repo is inside a container or on bare metal.
    *   *Update:* `prompts/roles/mise.md` needs instructions on how to validate the "Hybrid" environment.

2.  **`menu` (plan) -> The Architect**
    *   *Current Role:* Requirements & Specs.
    *   *New Responsibility:* Decides *which* mode a task requires.
    *   **Update:** When `plan` creates tasks in `_ENTRYPOINT.md`, it should explicitly link them to strict requirements.
*   **Traceability:** It should be possible to look at a task in `_ENTRYPOINT.md` and know exactly which Requirement ID it satisfies.

3.  **`cca` (pipe) -> The Bridge**
    *   *Current Role:* CLI Translator.
    *   *New Capability:* We can add "Pipe" prompts that control the infrastructure.
    *   *New Prompts:* `prompts/pipe/daytona.md` (e.g., `cca daytona "spin up frontend"` -> `daytona create ...`).

***

### Revised Architecture Integration

I will now generate the **ADR** and **PRD** specifically for the **Hybrid Agent Platform**, but I will write them *as if they are being added to your `comme-ca` repository*.

This means:
*   The **ADR** will live in `specs/ADR-001-hybrid-infrastructure.md` (inside your specs repo or `comme-ca`).
*   The **PRD** will reference your existing `comme-ca` roles (`mise`, `plan`, `audit`).

***

### `specs/ADR-001-hybrid-agent-infrastructure.md`

```markdown
# ADR 001: Hybrid Agent Infrastructure (Container Use + Daytona)

## Status
Accepted

## Context
We are scaling from serial, local-only agent interactions to parallel, asynchronous workflows. The `comme-ca` system currently handles *prompt orchestration* effectively but lacks an opinion on *compute orchestration*. We need a way to run multiple agents (using `comme-ca` roles) simultaneously without resource conflicts or manual "tab management."

We identified two distinct workload types:
1.  **Low Touch (Batch):** Tasks like "Refactor backend" or "Run Audit". These are high-autonomy, headless, and CLI-driven.
2.  **High Touch (Visual):** Tasks like "Fix CSS" or "Debug UI". These require a browser, visual feedback (VNC), and human-in-the-loop collaboration.

## Decision
We will implement a **Hybrid Infrastructure** on a single headless host, integrated into the `comme-ca` workflow.

1.  **Compute Primitives:**
    *   **Low Touch:** **Container Use (Dagger)**. Best for ephemeral, headless tasks.
    *   **High Touch:** **Daytona (Self-Hosted)**. Best for long-lived, visual tasks ("Computer Use").
    *   **Runtime:** **Docker**. Selected over Podman for better compatibility with Dagger sockets and VNC permissions.

2.  **Integration with `comme-ca`:**
    *   **`mise` (prep):** Will be updated to validate the presence of Daytona/Dagger and health-check the headless host connection.
    *   **`cca` (pipe):** Will gain new prompts to control these tools (e.g., `cca sand "new visual env"`).
    *   **`menu` (plan):** Will explicitly tag tasks in `_ENTRYPOINT.md` as `[HEADLESS]` or `[VISUAL]` to guide execution.

3.  **Future Proofing:**
    *   **Browserbase:** We acknowledge the need for anti-bot measures (shopping/scraping). We will strictly use **Daytona + OpenHands** for generic web tasks for now, and only plug in **Browserbase** via API if residential proxies become strictly necessary.

## Consequences
*   **Positive:** Decouples "thinking" (`comme-ca`) from "doing" (Infrastructure). Allows running 5+ `audit` or `refactor` agents in parallel.
*   **Negative:** Requires maintaining a headless host. Increases complexity of `mise` checks.

## Compliance
*   **Security:** All VNC/HTTP traffic routed strictly over Tailscale.
*   **Persistence:** Code remains on the self-hosted machine; ephemeral containers commit back to Git.
```

***

### `specs/PRD-001-hybrid-sandbox-platform.md`

```markdown
# PRD: Hybrid Agent Sandbox Platform
**Infrastructure for the `comme-ca` Intelligence System**

## 1. Purpose
To extend the `comme-ca` prompt orchestration system with a physical runtime environment that supports **parallel execution** and **visual feedback**. This platform transforms `comme-ca` from a "CLI helper" into a "Multi-Agent Fleet Commander."

## 2. User Stories
*   **As `menu` (The Architect),** I want to define a task as `[VISUAL]` so the execution agent knows to request a Daytona environment with a desktop.
*   **As a Developer,** I want to run `audit` (Taste) on three different branches simultaneously without them fighting over `localhost:3000`.
*   **As a Developer,** I want to run `cca sand "open frontend"` and instantly get a VNC window to a container where an agent is waiting for instructions.

## 3. Functional Requirements

### 3.1. The Headless Host
*   **OS:** Ubuntu LTS (or robust Linux distro).
*   **Network:** Tailscale Mesh.
*   **Services:**
    *   Docker Daemon (Rootful).
    *   Daytona Server.
    *   Dagger Engine (for Container Use).

### 3.2. "Low Touch" Mode (Container Use)
*   **Target Role:** `taste` (Audit), `refactor` agents.
*   **Workflow:**
    1.  User/Agent invokes `container-use`.
    2.  System spins up minimal container + Git Worktree.
    3.  `comme-ca` is injected/mounted into the container.
    4.  Agent runs `audit` inside the container.
*   **Output:** Git Branch + Report.

### 3.3. "High Touch" Mode (Daytona)
*   **Target Role:** Visual debugging, Frontend feature work.
*   **Workflow:**
    1.  User runs `daytona create --target=headless ...`.
    2.  Container boots with Xvfb/Fluxbox (Computer Use).
    3.  User connects via Browser (`http://headless:6080`) and Zed (SSH).
*   **Anti-Bot Strategy:**
    *   Default: Use standard Chromium inside Daytona.
    *   Escalation: If blocked, configure agent to use **Browserbase** API (Future Phase).

### 3.4. `comme-ca` Integration
*   **New Pipe Prompt:** `prompts/pipe/sandbox.md`.
    *   Usage: `cca sand "list environments"`, `cca sand "kill all audits"`.
*   **Drift Detection (`taste`):**
    *   Must be able to run *inside* a container and report back to the host (or commit to git).

## 4. Implementation Roadmap

### Phase 1: Infrastructure Setup (Low Lift)
1.  **Provision Host:** Docker + Tailscale + Daytona.
2.  **Update `mise`:** Add checks for `docker info` and `daytona server status`.
3.  **Create `sandbox.md`:** A new Pipe prompt to wrap `container-use` and `daytona` CLI commands.

### Phase 2: High Touch Pilot (High Lift)
1.  **Deploy OpenHands:** Run the OpenHands docker image on the headless host.
2.  **Verify Visuals:** Connect to OpenHands via Tailscale IP (`http://100.x.x.x:3000`).
3.  **Shopping Test:** Task OpenHands to "Go to Amazon and search for a GPU" to test basic anti-bot resilience (Headed Chrome).

### Phase 3: The "Fleet" Workflow
1.  **Parallel Audits:** Run 3 concurrent `audit` tasks using Container Use.
2.  **Browserbase Integration:** (Deferred) Add API key to `mise` secrets only when generic automation fails.

## 5. Success Criteria
*   **Concurrency:** 3 background agents + 1 foreground visual agent running simultaneously on the headless host.
*   **Integration:** `cca sand` command successfully controls remote containers from the local laptop.
*   **Experience:** User can view a remote agent clicking buttons in a browser via a local VNC/Web window with <150ms latency.
```

***

### Next Steps for You

1.  **Copy the ADR and PRD** above into your specs folder (or `comme-ca/specs/`).
2.  **Update `comme-ca`:**
    *   Add `prompts/pipe/sandbox.md` to wrap the `daytona` and `container-use` commands.
    *   Update `prompts/roles/mise.md` to include checks for Docker and Daytona.
3.  **Provision the Machine:** Get that headless box running Docker and Daytona.

This feels like a very solid, professional implementation of your vision. You are not just hacking scripts together; you are building a **platform**.
