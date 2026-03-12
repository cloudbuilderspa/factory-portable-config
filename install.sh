#!/usr/bin/env bash
#
# Factory Droid Portable Config - Installation Script
# Automatically installs TTS, hooks, and personal instructions
#
# Usage: ./install.sh [--dry-run]
#
# Requirements:
#   - Node.js (for edge-tts-universal)
#   - ffmpeg (for audio playback)
#   - Factory CLI installed

set -e

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "🔍 DRY RUN - No files will be modified"
fi

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FACTORY_DIR="${HOME}/.factory"

echo -e "${BLUE}🤖 Factory Droid Portable Config Installer${NC}"
echo ""

# Check dependencies
echo -e "${YELLOW}Checking dependencies...${NC}"

check_command() {
    if command -v "$1" &> /dev/null; then
        echo -e "  ${GREEN}✓${NC} $1 installed"
        return 0
    else
        echo -e "  ${YELLOW}✗${NC} $1 NOT installed"
        return 1
    fi
}

DEPS_OK=true
check_command node || DEPS_OK=false
check_command ffmpeg || DEPS_OK=false
check_command droid || DEPS_OK=false

if [[ "$DEPS_OK" == "false" ]]; then
    echo ""
    echo "❌ Missing dependencies. Please install them first:"
    echo "   - Node.js: https://nodejs.org"
    echo "   - ffmpeg: brew install ffmpeg"
    echo "   - Factory CLI: npm install -g @factory/cli"
    exit 1
fi

echo ""

# Install edge-tts-universal if not present
if [[ ! -d "${FACTORY_DIR}/node_modules/edge-tts-universal" ]]; then
    echo -e "${YELLOW}Installing edge-tts-universal...${NC}"
    if [[ "$DRY_RUN" == "false" ]]; then
        cd "$FACTORY_DIR"
        npm install edge-tts-universal --save 2>/dev/null || true
    fi
fi

# Copy files
echo -e "${YELLOW}Installing files...${NC}"

install_file() {
    local src="$1"
    local dest="$2"
    local desc="$3"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "  ${BLUE}→${NC} Would copy: $desc"
        echo "      $src → $dest"
    else
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
        chmod +x "$dest" 2>/dev/null || true
        echo -e "  ${GREEN}✓${NC} Installed: $desc"
    fi
}

# Install AGENTS.md
install_file "${SCRIPT_DIR}/AGENTS.md" "${FACTORY_DIR}/AGENTS.md" "Personal instructions"

# Install hooks
install_file "${SCRIPT_DIR}/hooks/droid-speak.sh" "${FACTORY_DIR}/hooks/droid-speak.sh" "TTS voice hook"
install_file "${SCRIPT_DIR}/hooks/mcp-keyword-detector.py" "${FACTORY_DIR}/hooks/mcp-keyword-detector.py" "MCP keyword detector"

# Install TTS binary
install_file "${SCRIPT_DIR}/bin/tts-speak" "${FACTORY_DIR}/bin/tts-speak" "TTS speak binary"

# Install voice scenarios config
install_file "${SCRIPT_DIR}/config/droid-voice-scenarios.json" "${FACTORY_DIR}/config/droid-voice-scenarios.json" "Voice scenarios config"

echo ""

if [[ "$DRY_RUN" == "false" ]]; then
    echo -e "${GREEN}✅ Installation complete!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Restart any active Droid sessions"
    echo "  2. Test TTS: ${FACTORY_DIR}/hooks/droid-speak.sh 'Hola mundo'"
    echo ""
    echo "Installed components:"
    echo "  • AGENTS.md - Personal instructions for all Droid sessions"
    echo "  • droid-speak.sh - Voice synthesis for task completions"
    echo "  • mcp-keyword-detector.py - Auto-invoke MCP tools by keywords"
    echo "  • tts-speak - Edge TTS binary for text-to-speech"
    echo "  • droid-voice-scenarios.json - Voice profiles by scenario"
else
    echo -e "${BLUE}Dry run complete. Run without --dry-run to install.${NC}"
fi
