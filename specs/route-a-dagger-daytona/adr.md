### 1. Executive Summary (The "Where We Landed")

We have defined a **Hybrid Agent Infrastructure** hosted on a single headless machine (accessed via Tailscale) to support concurrent, high-autonomy AI development workflows. This platform extends the existing `comme-ca` prompt orchestration system by providing a physical runtime layer.

The system employs a dual-mode architecture:
1.  **Low Touch (Batch):** Uses **Container Use (Dagger)** for lightweight, headless, CLI-driven tasks (refactoring, auditing) running in parallel.
2.  **High Touch (Visual):** Uses **Daytona** (self-hosted) with **Computer Use** capabilities for interactive, visual tasks (frontend debugging, shopping automation) requiring a desktop environment and VNC.

This replaces the manual management of local tabs/windows with a centralized "Fleet Commander" model, where the user delegates tasks to isolated environments managed by the `comme-ca` CLI.

### 2. The Narrative Arc (The "Spark")

*   **Trigger:** The user sought a better workflow for managing multiple parallel AI-assisted projects, struggling with "tab chaos" and resource contention on a local machine.
*   **Pivot:** The initial request for a "remote sandbox" evolved into a deeper analysis of **agent autonomy levels**. We realized that "refactoring a backend" (headless) and "fixing a UI" (visual) have fundamentally different infrastructure needs.
*   **Relationship:** We are solving the **cognitive load of managing parallel AI agents** by implementing a **Hybrid Container Infrastructure** that routes tasks to the appropriate runtime (headless Dagger container vs. headed Daytona desktop) based on the task type defined in `comme-ca`.

### 3. 📚 Critical Resources & References

*   **Container Use (Dagger):** [GitHub Repository](https://github.com/dagger/container-use) - The core engine for the "Low Touch" headless agent workflow.
*   **Daytona:** [Official Documentation](https://www.daytona.io/docs) - The platform for managing "High Touch" development environments.
*   **Daytona "Computer Use" Templates:** [Reference](https://www.daytona.io/docs/llms-full.txt) - Documentation on spinning up VNC-enabled containers.
*   **OpenHands:** [Project Site](https://openhands.daytona.io) - The recommended "all-in-one" visual agent interface for high-touch tasks.
*   **Tailscale:** [Documentation](https://tailscale.com) - The networking layer securing the headless machine.

### 4. System Architecture (The "Law")

#### The Hybrid Runtime
The architecture is split into two distinct planes running on the **Headless Host**:

| Plane | Tool | Characteristics | Use Case |
| :--- | :--- | :--- | :--- |
| **Background (Batch)** | **Container Use** | Ephemeral, headless, fast boot, low RAM. | `audit`, `refactor`, `test`, `data-processing` |
| **Foreground (Visual)** | **Daytona** | Long-lived, persistent, GUI (X11/VNC), high RAM. | `frontend-dev`, `visual-debug`, `shopping`, `browser-automation` |

#### Integration with `comme-ca`
The `comme-ca` repository serves as the "Control Plane":
*   **`mise` (prep):** Validates infrastructure health (Docker, Daytona daemon).
*   **`cca` (pipe):** Provides the CLI interface (`cca sand ...`) to spawn environments.
*   **`menu` (plan):** Categorizes work items as `[HEADLESS]` or `[VISUAL]`.

#### Networking & Security
*   **Binding:** All services bind to `0.0.0.0` inside containers but are exposed *only* to the Tailscale network interface of the host.
*   **Access:** User connects via SSH (Zed) or HTTP (Browser) using the host's Tailscale IP. No ports are exposed to the public internet.

### 5. Feature Specification (The "Instance")

#### The "Sandbox" Pipe (`prompts/pipe/sandbox.md`)
A new CLI tool to manage the infrastructure.

**Logic Flow:**
1.  **Parse Input:** User runs `cca sand "spin up audit for feature-x"`.
2.  **Determine Type:** Agent determines if this is a headless or visual task.
3.  **Execute Command:**
    *   *If Headless:* `container-use create --name feature-x ...`
    *   *If Visual:* `daytona create --target headless --name feature-x ...`
4.  **Output:** Connection string (e.g., `ssh://feature-x` or `http://tailscale-ip:6080`).

#### The "Mise" Update (`prompts/roles/mise.md`)
Updated system prompt for the bootstrapper.

**New Directives:**
*   **Check Docker:** Ensure `docker info` returns success.
*   **Check Daytona:** Ensure `daytona server status` is running.
*   **Check Network:** Verify Tailscale IP is reachable.
*   **Check Permissions:** Warn if user is running rootless Podman (due to known VNC/Dagger friction).

### 6. Decision Record (Rationale)

#### Infrastructure Decisions
*   **Why Docker (not Podman)?**
    *   **Rationale:** Pragmatism. Dagger (Container Use) relies heavily on the Docker socket. Daytona's "Computer Use" templates (VNC/X11) require privileged flags that are notoriously difficult to configure in rootless Podman.
    *   **Rejected Alternative:** Rootless Podman. While architecturally purer, the configuration overhead for VNC and socket mounting was deemed too high for a "Low Lift" start.
*   **Why Hybrid (not just one tool)?**
    *   **Rationale:** Resource efficiency. Running 5 full Desktop containers (Daytona) for simple background audits wastes RAM. Running 5 headless containers (Container Use) makes visual debugging impossible. We need both.

#### Tool Decisions
*   **Why Container Use (Dagger)?**
    *   **Rationale:** It natively handles **Git Worktrees**, solving the "branch switching" concurrency problem automatically. It is designed specifically for "agents spawning agents."
*   **Why Daytona (Visuals)?**
    *   **Rationale:** It provides a managed wrapper around "DevContainers," handling the SSH plumbing and lifecycle management better than raw Docker commands. It has native support for "Computer Use" (VNC).
*   **Why OpenHands (Optional)?**
    *   **Rationale:** It bundles the "Agent + Browser + Chat" into a single Docker image, providing an instant "High Touch" environment without configuring a custom Zed+VNC workflow from scratch.

#### Anti-Bot Strategy
*   **Decision:** Use standard Headless/Headed Chrome (via Daytona/OpenHands) for all internal and low-security external tasks.
*   **Deferred:** **Browserbase** (Residential Proxies) is reserved as a future plugin if/when IP blocking becomes a blocker for shopping tasks.

### 7. Confirmed Constraints & Preferences
*   **Hardware:** User has a dedicated "Headless Dev Machine."
*   **Network:** User utilizes **Tailscale** (Tailnet).
*   **Existing Tooling:** User relies on `comme-ca` (Goose/Claude) for orchestration.
*   **Editor:** User prefers **Zed** (via SSH).
*   **Philosophy:** Strong preference for "Self-Hosted" and "Data Privacy."

### 8. ❓ Open Questions & Assumptions
*   **Assumption:** The headless machine has sufficient RAM (32GB+) to run multiple concurrent desktop containers.
*   **Assumption:** The user has root access on the headless machine to install the Docker daemon.
*   **Unknown:** Whether the user's specific shopping targets (if any) require advanced fingerprint spoofing immediately, or if standard Chrome is sufficient. (Assumed standard is fine for now).
