<!--
@id: readme
@version: 1.0.0
@model: claude-3-5-sonnet-20241022
-->
# {{PROJECT_NAME}}

[Project description goes here]

## Setup

```bash
# Install dependencies
# [Add your setup instructions]

# Run the project
# [Add your run instructions]
```

## Development

This project uses [comme-ca](https://github.com/popscallion/comme-ca) for agent orchestration.

### Available Commands

```bash
prep   # Validate environment and dependencies
plan   # Create feature specifications
audit  # Check for drift between SPECS and implementation
```

### Project Structure

```
{{PROJECT_SLUG}}/
├── SPECS/           # Feature specifications (feature-*)
├── DOCS/            # Durable documentation
├── _INBOX/          # Intake buffer (triage first)
├── REQUIREMENTS.md  # Project constraints and requirements
├── DESIGN.md        # Technical architecture
├── AGENTS.md        # Agent orchestration rules
├── CLAUDE.md        # AI assistant configuration (Claude)
├── GEMINI.md        # AI assistant configuration (Gemini)
└── CODEX.md         # AI assistant configuration (Codex)
```

## Contributing

[Add contribution guidelines]

## License

This project is licensed under the terms specified in the LICENSE file.
