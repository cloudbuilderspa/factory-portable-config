#!/usr/bin/env bash
#
# Factory Droid Portable Config - Local Installation Script
# Run this after cloning the repo
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
BACKUP_DIR="${HOME}/.factory-backup-$(date +%Y%m%d_%H%M%S)"

echo -e "${BLUE}🤖 Factory Droid Portable Config Installer${NC}"
echo ""

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*)    echo "macos" ;;
        Linux*)     echo "linux" ;;
        *)          echo "unknown" ;;
    esac
}

OS=$(detect_os)

# Check dependencies
echo -e "${YELLOW}Checking dependencies...${NC}"

check_command() {
    if command -v "$1" &> /dev/null; then
        echo -e "  ${GREEN}✓${NC} $1 installed ($(command -v $1))"
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

# Check uv (optional, for AWS MCPs)
if check_command uv; then
    :
else
    echo -e "  ${BLUE}ℹ${NC} uv not installed (optional, for AWS MCPs)"
fi

if [[ "$DEPS_OK" == "false" ]]; then
    echo ""
    echo "❌ Missing required dependencies. Please install them first:"
    echo "   - Node.js: https://nodejs.org"
    if [[ "$OS" == "macos" ]]; then
        echo "   - ffmpeg: brew install ffmpeg"
    else
        echo "   - ffmpeg: sudo apt install ffmpeg"
    fi
    echo "   - Factory CLI: npm install -g @factory/cli"
    echo ""
    echo "Optional for AWS MCPs:"
    echo "   - uv: curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
fi

echo ""

# Create directories
echo -e "${YELLOW}Setting up directories...${NC}"
mkdir -p "${FACTORY_DIR}"/{hooks,bin,config,node_modules,droids,skills}

# Backup existing files
echo -e "${YELLOW}Creating backup of existing files...${NC}"

backup_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        local rel_path="${file#$FACTORY_DIR/}"
        local backup_path="${BACKUP_DIR}/${rel_path}"
        mkdir -p "$(dirname "$backup_path")"
        cp "$file" "$backup_path"
        echo -e "  ${BLUE}↩${NC} Backed up: $rel_path"
    fi
}

backup_dir() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        local rel_path="${dir#$FACTORY_DIR/}"
        local backup_path="${BACKUP_DIR}/${rel_path}"
        mkdir -p "$backup_path"
        cp -r "$dir"/* "$backup_path"/ 2>/dev/null || true
        echo -e "  ${BLUE}↩${NC} Backed up: $rel_path/"
    fi
}

if [[ "$DRY_RUN" == "false" ]]; then
    backup_file "${FACTORY_DIR}/AGENTS.md"
    backup_file "${FACTORY_DIR}/hooks/droid-speak.sh"
    backup_file "${FACTORY_DIR}/hooks/mcp-keyword-detector.py"
    backup_file "${FACTORY_DIR}/bin/tts-speak"
    backup_file "${FACTORY_DIR}/config/droid-voice-scenarios.json"
    backup_file "${FACTORY_DIR}/mcp.json"
    backup_dir "${FACTORY_DIR}/droids"
    backup_dir "${FACTORY_DIR}/skills"

    if [[ -d "$BACKUP_DIR" ]] && [[ -n "$(ls -A $BACKUP_DIR 2>/dev/null)" ]]; then
        echo -e "${GREEN}✓${NC} Backup created at: ${BACKUP_DIR}"
    else
        echo -e "${BLUE}ℹ${NC} No existing files to backup"
    fi
else
    echo "  Would backup existing files to: ${BACKUP_DIR}"
fi

# Install edge-tts-universal
echo ""
echo -e "${YELLOW}Installing TTS engine (edge-tts-universal)...${NC}"
if [[ "$DRY_RUN" == "false" ]]; then
    mkdir -p "${FACTORY_DIR}"
    cd "$FACTORY_DIR"
    if [[ ! -f "package.json" ]]; then
        npm init -y 2>/dev/null || true
    fi
    if [[ ! -d "node_modules/edge-tts-universal" ]]; then
        npm install edge-tts-universal --save 2>/dev/null
        echo -e "  ${GREEN}✓${NC} edge-tts-universal installed"
    else
        echo -e "  ${GREEN}✓${NC} edge-tts-universal already installed"
    fi
fi

# Copy files
echo ""
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

# Install droids
echo ""
echo -e "${YELLOW}Installing custom droids...${NC}"
if [[ "$DRY_RUN" == "false" ]]; then
    mkdir -p "${FACTORY_DIR}/droids"
    if [[ -d "${SCRIPT_DIR}/droids" ]]; then
        cp -r "${SCRIPT_DIR}/droids"/* "${FACTORY_DIR}/droids/"
        echo -e "  ${GREEN}✓${NC} Custom droids installed"
    fi
fi

# Install skills
echo ""
echo -e "${YELLOW}Installing skills...${NC}"
if [[ "$DRY_RUN" == "false" ]]; then
    mkdir -p "${FACTORY_DIR}/skills"
    if [[ -d "${SCRIPT_DIR}/skills" ]]; then
        cp -r "${SCRIPT_DIR}/skills"/* "${FACTORY_DIR}/skills/"
        echo -e "  ${GREEN}✓${NC} Skills installed"
    fi
fi

# Setup MCP config
if [[ "$DRY_RUN" == "false" ]]; then
    echo ""
    echo -e "${YELLOW}Setting up MCP configuration...${NC}"
    if [[ ! -f "${FACTORY_DIR}/mcp.json" ]]; then
        cp "${SCRIPT_DIR}/mcp-servers.example.json" "${FACTORY_DIR}/mcp.json"
        echo -e "  ${GREEN}✓${NC} Created mcp.json from template"
    else
        echo -e "  ${BLUE}ℹ${NC} mcp.json already exists, keeping it"
    fi
fi

echo ""

if [[ "$DRY_RUN" == "false" ]]; then
    # Test TTS
    echo -e "${YELLOW}Testing TTS...${NC}"
    "${FACTORY_DIR}/hooks/droid-speak.sh" "Instalación completada" &
    sleep 1
    
    echo ""
    echo -e "${GREEN}✅ Installation complete!${NC}"
    if [[ -d "$BACKUP_DIR" ]] && [[ -n "$(ls -A $BACKUP_DIR 2>/dev/null)" ]]; then
        echo -e "${BLUE}📦 Backup saved to: ${BACKUP_DIR}${NC}"
    fi
    echo ""
    echo "Installed components:"
    echo "  • AGENTS.md - Personal instructions"
    echo "  • TTS Voice System - droid-speak.sh + edge-tts-universal"
    echo "  • MCP Auto-Invoke - Keyword detection for 15+ MCPs"
    echo "  • MCP Servers Template - 18 pre-configured MCPs"
    echo "  • Custom Droids - worker, docs-fetcher, scrutiny, user-testing"
    echo "  • Skills - context7-docs, xlsx-official"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. Add your API keys to ~/.factory/mcp.json:"
    echo "     - Context7: https://context7.com"
    echo "     - GitHub:   https://github.com/settings/tokens"
    echo ""
    echo "  2. Restart any active Droid sessions"
    echo ""
    echo "  3. Test the setup:"
    echo "     ~/.factory/hooks/droid-speak.sh 'Hola mundo'"
else
    echo -e "${BLUE}Dry run complete. Run without --dry-run to install.${NC}"
fi
