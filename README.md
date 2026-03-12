# Factory Droid Portable Config

Personal configuration for Factory Droid that can be easily transferred between machines.

## Quick Start

```bash
# Clone this repo
git clone <your-repo-url> factory-portable-config
cd factory-portable-config

# Run installer
./install.sh

# Or test first with dry-run
./install.sh --dry-run
```

## What's Included

| File | Description |
|------|-------------|
| `AGENTS.md` | Personal instructions for all Droid sessions (MCP auto-invoke rules, code style, TTS settings) |
| `hooks/droid-speak.sh` | Voice synthesis hook - Droid speaks after task completions |
| `hooks/mcp-keyword-detector.py` | Auto-detects keywords and invokes appropriate MCP tools |
| `bin/tts-speak` | Edge TTS binary for text-to-speech using Microsoft Edge voices |
| `config/droid-voice-scenarios.json` | Voice profiles mapped to scenarios (cloud, debug, research, etc.) |
| `mcp-servers.example.json` | MCP servers configuration template (sanitized) |

## Requirements

- Node.js (for edge-tts-universal)
- ffmpeg (for audio playback)
- Python 3 + uv (for AWS MCPs)
- Factory CLI (`npm install -g @factory/cli`)

## MCP Servers Setup

### 1. Copy the template
```bash
cp mcp-servers.example.json ~/.factory/mcp.json
```

### 2. Add your API keys

Replace the placeholders in `~/.factory/mcp.json`:

| MCP | Placeholder | Where to get |
|-----|-------------|--------------|
| `context7` | `YOUR_CONTEXT7_API_KEY` | https://context7.com |
| `github` | `YOUR_GITHUB_PAT` | https://github.com/settings/tokens (needs `repo`, `issues` scopes) |

### 3. Included MCPs (18 total)

| Category | MCPs |
|----------|------|
| **AWS** | aws-knowledge, aws-documentation, aws-pricing, aws-cdk-mcp, localstack |
| **Cloud/Serverless** | vercel, supabase, firebase |
| **Dev Tools** | github, memory, sequential-thinking |
| **Browser/Testing** | playwright, chrome-devtools |
| **Diagrams** | drawio-mcp, excalidraw-mcp |
| **Docs** | context7 |

## Manual Installation

If you prefer to copy files manually:

```bash
# Copy to Factory directory
cp AGENTS.md ~/.factory/
cp hooks/* ~/.factory/hooks/
cp bin/tts-speak ~/.factory/bin/
cp config/droid-voice-scenarios.json ~/.factory/config/
cp mcp-servers.example.json ~/.factory/mcp.json

# Install TTS dependency
cd ~/.factory
npm install edge-tts-universal --save

# Add your API keys to mcp.json
# Replace YOUR_CONTEXT7_API_KEY and YOUR_GITHUB_PAT
```

## Customization

### Add New Voice Scenarios

Edit `config/droid-voice-scenarios.json`:

```json
{
  "scenarios": {
    "my_custom_scenario": {
      "keywords": ["custom", "keywords"],
      "voice": "es-ES-AlvaroNeural",
      "messages": {
        "start": "Starting...",
        "success": "Done!",
        "error": "Failed."
      }
    }
  }
}
```

### Add New MCP Auto-Invoke Rules

Edit `hooks/mcp-keyword-detector.py` to add new keyword patterns.

## Voice Options

Available Spanish voices:
- `es-CL-CatalinaNeural` - Chile (Female)
- `es-ES-AlvaroNeural` - Spain (Male)
- `es-ES-ElviraNeural` - Spain (Female)
- `es-ES-XimenaNeural` - Spain (Female)
- `es-MX-JorgeNeural` - Mexico (Male)
- `es-AR-ElenaNeural` - Argentina (Female)
- `es-AR-TomasNeural` - Argentina (Male)
- `es-CO-GonzaloNeural` - Colombia (Male)

List all voices: `~/.factory/bin/tts-speak --list`
