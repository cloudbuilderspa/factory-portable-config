# Factory Droid Portable Config

Personal configuration for Factory Droid with TTS voice, MCP auto-invoke, and personal instructions.

## 🚀 Quick Install (One Command)

```bash
curl -fsSL https://raw.githubusercontent.com/cloudbuilderspa/factory-portable-config/main/quick-install.sh | bash
```

This will automatically install:
- ✅ Node.js (if not present)
- ✅ ffmpeg (for audio playback)
- ✅ uv (for AWS MCPs)
- ✅ edge-tts-universal (TTS engine)
- ✅ All hooks and configuration files

## 📦 What's Included

| Component | Description |
|-----------|-------------|
| **AGENTS.md** | Personal instructions for all Droid sessions |
| **TTS Voice** | Voice synthesis - Droid speaks after task completions |
| **MCP Auto-Invoke** | Auto-detects keywords and invokes appropriate MCP tools |
| **MCP Servers** | 18 pre-configured MCP servers template |

## 🔧 MCP Servers (18 included)

| Category | MCPs |
|----------|------|
| **AWS** | aws-knowledge, aws-documentation, aws-pricing, aws-cdk-mcp, localstack |
| **Cloud/Serverless** | vercel, supabase, firebase |
| **Dev Tools** | github, memory, sequential-thinking |
| **Browser/Testing** | playwright, chrome-devtools |
| **Diagrams** | drawio-mcp, excalidraw-mcp |
| **Docs** | context7 |

## 🔑 API Keys Setup

After installation, add your API keys to `~/.factory/mcp.json`:

```bash
# Edit the file
nano ~/.factory/mcp.json
```

Replace these placeholders:
- `YOUR_CONTEXT7_API_KEY` → Get at https://context7.com
- `YOUR_GITHUB_PAT` → Create at https://github.com/settings/tokens (needs `repo` scope)

## 🎤 Voice Scenarios

The TTS system uses different voices based on context:

| Scenario | Voice | Language |
|----------|-------|----------|
| Software Development | Jorge | Spanish (Mexico) |
| Cloud/AWS | Alvaro | Spanish (Spain) |
| AI Architecture | Catalina | Spanish (Chile) |
| Debug | Tomas | Spanish (Argentina) |
| Research | Ximena | Spanish (Spain) |

Test voice: `~/.factory/hooks/droid-speak.sh "Hola mundo"`

## 📋 Manual Installation

If you prefer manual setup:

```bash
# Clone repo
git clone https://github.com/cloudbuilderspa/factory-portable-config.git
cd factory-portable-config

# Run installer
./install.sh

# Or copy files manually
cp AGENTS.md ~/.factory/
cp hooks/* ~/.factory/hooks/
cp bin/tts-speak ~/.factory/bin/
cp config/droid-voice-scenarios.json ~/.factory/config/
cp mcp-servers.example.json ~/.factory/mcp.json

# Install TTS dependency
cd ~/.factory && npm install edge-tts-universal --save
```

## 🔄 Update

Re-run the quick install command to update:

```bash
curl -fsSL https://raw.githubusercontent.com/cloudbuilderspa/factory-portable-config/main/quick-install.sh | bash
```

## 📁 Directory Structure

```
~/.factory/
├── AGENTS.md                    # Personal instructions
├── mcp.json                     # MCP servers config (from template)
├── hooks/
│   ├── droid-speak.sh          # TTS voice hook
│   └── mcp-keyword-detector.py # MCP auto-invoke
├── bin/
│   └── tts-speak               # Edge TTS binary
├── config/
│   └── droid-voice-scenarios.json
└── node_modules/
    └── edge-tts-universal/     # TTS engine
```

## ⚙️ How It Works

```
User sends prompt
       │
       ▼
┌──────────────────────────────┐
│ mcp-keyword-detector.py      │
│ Detects: aws, react, github  │
│ Injects MCP instructions     │
└──────────────────────────────┘
       │
       ▼
┌──────────────────────────────┐
│ Droid + AGENTS.md            │
│ Processes with personal      │
│ instructions loaded          │
└──────────────────────────────┘
       │
       ▼
┌──────────────────────────────┐
│ Task completed               │
│ droid-speak.sh → tts-speak   │
│ "Listo. Completé la tarea."  │
└──────────────────────────────┘
```

## 📜 License

MIT - Use freely for your Factory Droid setup.
