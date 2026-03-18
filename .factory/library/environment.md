# Environment

Environment variables, external dependencies, and setup notes.

## What belongs here
- Required env vars
- External dependencies
- Platform-specific notes

## What does NOT belong here
- Service ports/commands (use `.factory/services.yaml`)

## Environment Details

### Required Dependencies
- Node.js 18+ (for edge-tts-universal)
- ffmpeg (for audio playback)
- curl (for downloading files)
- git (for version control)

### Optional Dependencies
- uv (for AWS MCPs)
- python3 (for mcp-keyword-detector.py)

### Environment Variables
- `FACTORY_DIR` - Override default ~/.factory location
- `MCP_DETECTOR_DEBUG` - Enable debug output for MCP detector

### Platform Notes

#### macOS
- Install via Homebrew: `brew install node ffmpeg`
- Python3 pre-installed on newer macOS versions

#### Linux
- Install via apt: `sudo apt install nodejs ffmpeg`
- May need `sudo` for system-wide installs

### Installation Flow
1. Run `quick-install.sh` for full installation
2. Or run `quick-install-interactive.sh` for selective installation
3. Or clone repo and run `./install.sh`
