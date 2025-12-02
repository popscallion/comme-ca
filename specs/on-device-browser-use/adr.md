1. Executive Summary (The "Where We Landed")
The user plans to prototype two distinct agentic system architectures for local execution on a MacBook M4 (32GB RAM):
Monolithic VLM: A single, large Qwen3-VL-8B model handling all reasoning and browser interaction.
Heterogeneous MCP (Model Context Protocol): A small orchestrator (SmolVLM-500M) dispatching tasks to specialized tools/functions.
The Specific Task that triggered this decision was identifying the optimal sweet spot for an on-device general-purpose reasoning agent capable of browser control.
2. The Narrative Arc (The "Spark")
Trigger: The user initially asked about the smallest reasonably smart on-device vision model available in Nov 2025.
Pivot: The conversation quickly narrowed to models specifically designed for browser control and computer automation (Fara-7B), evolving into a high-level discussion on architectural patterns (monolithic vs. orchestrated) suitable for their powerful local hardware.
Relationship: We are solving on-device browser automation and general reasoning by implementing two distinct agentic system architectures for direct comparison.
3. 📚 Critical Resources & References
See Ollama Library for Qwen-VL for local deployment instructions on macOS.
See Hugging Face Model Card for SmolVLM-500M for model weights and architecture details.
See Microsoft's research papers on Fara-7B (e.g., Agents on Graphical Interfaces) for specific UI interaction training methodologies [INFERRED].
See documentation on the Model Context Protocol (MCP) pattern for details on orchestrator/tool coordination [INFERRED].
4. System Architecture (The "Law")
The architecture must support two parallel experimental tracks on a single macOS host:
Track A: Monolithic VLM (Qwen3-VL-8B)
Workflow:
User prompt is captured by a local client (e.g., using Llama.cpp/Ollama).
The client takes a screenshot of the browser.
Prompt + Image + Full System Context (previous steps, goal) is sent to the Qwen3-VL-8B model instance running in memory.
The model outputs a structured response (e.g., JSON action: {"action": "click", "coordinates": [x, y]}).
The client executes the action via OS-level automation libraries (e.g., AppleScript, Python pyautogui).
Operational Risks: Higher VRAM usage (8GB+), slower inference latency per step compared to text-only models, complex context management for long tasks.
Track B: Heterogeneous MCP (SmolVLM-500M orchestrator)
Workflow:
User prompt is captured.
SmolVLM-500M analyzes screenshot and prompt to select a tool (e.g., BrowserTool_Click(x,y), DataExtractionTool()).
The selected tool (which is pure, optimized code) executes the task.
Tool output is returned to SmolVLM for the next decision loop.
Operational Risks: Orchestration logic is more complex to engineer; SmolVLM's limited reasoning capacity might fail on novel or highly complex UI layouts without extensive fine-tuning.
5. Feature Specification (The "Instance")
The specific "feature" is enabling an agent to select and interact with a browser button element:
Monolithic Implementation:
Input to Model: [System Prompt to output JSON actions] + [Screenshot_Base64] + "Click the 'Sign In' button."
Model Output: {"action": "click", "element_description": "Sign In button", "coordinates": [120, 450]}
Execution: The client script uses the coordinates to execute the OS-level mouse click.
MCP Implementation:
Input to SmolVLM: [Orchestrator Prompt] + [Screenshot] + "Click 'Sign In'."
SmolVLM Decision: Calls internal function select_element(description="Sign In button").
Tool Execution: The dedicated select_element tool uses a separate, potentially non-AI, vision library (e.g., OpenCV template matching) to find the coordinates and execute the click.
6. Decision Record (Rationale)
System Decisions: The user is exploring both approaches. The single-model approach is recommended as the "sweet spot" for simplicity on M4 hardware due to Apple's unified memory benefits, minimizing inter-process communication overhead. The MCP approach is valid for highly optimized performance/latency needs.
Feature Decisions: Both rely heavily on the VLM's ability to localize objects visually and output structured action commands. Text-only models (Gemma 350M/Granite 4 270M) were rejected as fundamentally incapable of interpreting visual browser state. Fara-7B was noted as excellent but potentially less general-purpose than Qwen3-VL-8B.
7. Confirmed Constraints & Preferences
Hardware: MacBook M4 with 32GB RAM.
Environment: On-device execution (local inference).
Goal: General purpose reasoning plus browser control (agentic capabilities).
Preference: Exploring the "sweet spot" between capability and size, exploring two distinct architectural patterns.
Timeline Context: All information is accurate as of November 2025.
8. ❓ Open Questions & Assumptions
UNKNOWN: Specific OS version and automation libraries available (e.g., using pyautogui vs. native AppleScript/Swift).
ASSUMPTION: We assume standard Python automation libraries are available and compatible with the user's macOS version.
UNKNOWN: The user's required latency (response time) per agent step.
ASSUMPTION: A balance of speed and intelligence (e.g., 8B parameter inference speed on M4) is acceptable for prototyping.
