# Architecture

## Directory Structure

```
factory-portable-config/
├── .factory/              # Mission infrastructure
│   ├── skills/           # Worker skills
│   ├── library/          # Knowledge base
│   ├── services.yaml     # Command/service definitions
│   └── init.sh            # Setup script
├── tests/                # Automated tests (bats)
├── hooks/               # Factory hooks
│   ├── droid-speak.sh   # TTS voice hook
│   └── mcp-keyword-detector.py  # MCP auto-invoke
├── bin/                # Executables
│   └── tts-speak        # TTS binary
├── config/             # Configuration
│   └── droid-voice-scenarios.json  # Voice scenarios
├── droids/            # Custom droids
├── skills/            # Skills
├── mission-includes/  # Mission includes
├── AGENTS.md          # Personal instructions
├── install.sh         # Local installer
├── quick-install.sh   # Remote quick installer
├── quick-install-interactive.sh  # Interactive installer
└── sync-to-repo.sh    # Sync to GitHub
```

## Key Files

### quick-install.sh
- Main installation script
- Installs all dependencies
- Downloads all files from GitHub
- Runs TTS test

### quick-install-interactive.sh
- Interactive component selection
- Allows selecting specific components to install
- Supports --dry-run, --self-test, --selections flags

### droid-speak.sh
- TTS voice hook
- Maps scenarios to voices
- Uses edge-tts-universal for synthesis

### mcp-keyword-detector.py
- Detects MCP-related keywords in prompts
- Injects MCP usage instructions
- Separates AWS pricing from services
