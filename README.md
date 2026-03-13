# Factory Droid Portable Config

Personal configuration for Factory Droid with TTS voice, MCP auto-invoke, and personal instructions.

## Quick Install (One Command)

```bash
curl -fsSL https://raw.githubusercontent.com/cloudbuilderspa/factory-portable-config/main/quick-install.sh | bash
```

This will automatically install:
- Node.js (if not present)
- ffmpeg (for audio playback)
- uv (for AWS MCPs)
- edge-tts-universal (TTS engine)
- All hooks and configuration files

## Interactive Install

Select what you want to install:

```bash
curl -fsSL https://raw.githubusercontent.com/cloudbuilderspa/factory-portable-config/main/quick-install-interactive.sh | bash
```

Options: AGENTS.md, TTS Voice, MCP Auto-Invoke, MCP Servers, Skills, Droids, Mission Includes.

## What's Included

| Component | Description |
|-----------|-------------|
| AGENTS.md | Personal instructions for all Droid sessions |
| TTS Voice | Voice synthesis - Droid speaks after task completions |
| MCP Auto-Invoke | Auto-detects keywords and invokes appropriate MCP tools |
| MCP Servers | 18 pre-configured MCP servers template |
| Skills | context7-docs, xlsx-official |
| Droids | 17 BMAD droids + custom droids (worker, docs-fetcher, etc.) |
| Mission Includes | AGENTS-PERSONAL.md for Factory missions |

## API Keys Setup

After installation, add your API keys to `~/.factory/mcp.json`:

```bash
nano ~/.factory/mcp.json
```

Replace these placeholders:
- `YOUR_CONTEXT7_API_KEY` -> Get at https://context7.com
- `YOUR_GITHUB_PAT` -> Create at https://github.com/settings/tokens (needs `repo` scope)

## Voice Scenarios

The TTS system uses different voices based on context:

| Scenario | Voice | Language |
|----------|-------|----------|
| Software Development | Jorge | Spanish (Mexico) |
| Cloud/AWS | Alvaro | Spanish (Spain) |
| AI Architecture | Catalina | Spanish (Chile) |
| Debug | Tomas | Spanish (Argentina) |
| Research | Ximena | Spanish (Spain) |

Test voice: `~/.factory/hooks/droid-speak.sh "Hola mundo"`

## Manual Installation

If you prefer manual setup:

```bash
# Clone repo
git clone https://github.com/cloudbuilderspa/factory-portable-config.git
cd factory-portable-config

# Run installer
./install.sh
```

## Development Workflow

```bash
# Develop in ~/.factory/
# Add new MCPs, hooks, skills, droids

# Sync to repo (sanitizes tokens)
cd ~/.factory/factory-portable-config
./sync-to-repo.sh --commit --push
```

## Directory Structure

```
~/.factory/
├── AGENTS.md                    # Personal instructions
├── mcp.json                     # MCP servers config
├── hooks/
│   ├── droid-speak.sh          # TTS voice hook
│   └── mcp-keyword-detector.py # MCP auto-invoke
├── bin/
│   └── tts-speak               # Edge TTS binary
├── config/
│   └── droid-voice-scenarios.json
├── droids/                     # Custom droids
├── skills/                     # Custom skills
├── mission-includes/           # Config for Factory missions
└── node_modules/
    └── edge-tts-universal/     # TTS engine
```

## How It Works

```
User sends prompt
       |
       v
mcp-keyword-detector.py
Detects: aws, react, github
Injects MCP instructions
       |
       v
Droid + AGENTS.md
Processes with personal instructions
       |
       v
Task completed
droid-speak.sh -> tts-speak
"Listo. Complete la tarea."
```

## License

MIT - Use freely for your Factory Droid setup.
