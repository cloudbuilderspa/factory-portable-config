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

## Requirements

- Node.js (for edge-tts-universal)
- ffmpeg (for audio playback)
- Factory CLI (`npm install -g @factory/cli`)

## Manual Installation

If you prefer to copy files manually:

```bash
# Copy to Factory directory
cp AGENTS.md ~/.factory/
cp hooks/* ~/.factory/hooks/
cp bin/tts-speak ~/.factory/bin/
cp config/droid-voice-scenarios.json ~/.factory/config/

# Install TTS dependency
cd ~/.factory
npm install edge-tts-universal --save
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
