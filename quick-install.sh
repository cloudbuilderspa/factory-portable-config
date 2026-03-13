#!/usr/bin/env bash
#
# Factory Droid Portable Config - Quick Install Script
# Installs TTS, hooks, MCP config, personal instructions, custom droids, skills, and mission includes
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/cloudbuilderspa/factory-portable-config/main/quick-install.sh | bash
#
# Requirements:
#   - curl, git
#   - Will install: node, ffmpeg, uv (if not present)

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

REPO_URL="https://github.com/cloudbuilderspa/factory-portable-config"
RAW_URL="https://raw.githubusercontent.com/cloudbuilderspa/factory-portable-config/main"
FACTORY_DIR="${HOME}/.factory"
BACKUP_DIR="${HOME}/.factory-backup-$(date +%Y%m%d_%H%M%S)"

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║     Factory Droid Portable Config - Quick Installer        ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*)    echo "macos" ;;
        Linux*)     echo "linux" ;;
        *)          echo "unknown" ;;
    esac
}

OS=$(detect_os)
echo -e "${YELLOW}Detected OS: ${OS}${NC}"

# Check if Factory CLI is installed
if ! command -v droid &> /dev/null; then
    echo -e "${RED}❌ Factory CLI not found. Please install it first:${NC}"
    echo "   npm install -g @factory/cli"
    exit 1
fi
echo -e "${GREEN}✓${NC} Factory CLI found"

# Install dependencies
echo ""
echo -e "${YELLOW}Installing dependencies...${NC}"

# Node.js
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}Installing Node.js...${NC}"
    if [[ "$OS" == "macos" ]]; then
        brew install node
    elif [[ "$OS" == "linux" ]]; then
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
fi
echo -e "${GREEN}✓${NC} Node.js: $(node --version)"

# ffmpeg
if ! command -v ffmpeg &> /dev/null; then
    echo -e "${YELLOW}Installing ffmpeg...${NC}"
    if [[ "$OS" == "macos" ]]; then
        brew install ffmpeg
    elif [[ "$OS" == "linux" ]]; then
        sudo apt-get install -y ffmpeg
    fi
fi
echo -e "${GREEN}✓${NC} ffmpeg: $(ffmpeg -version | head -1 | cut -d' ' -f3)"

# uv (for AWS MCPs)
if ! command -v uv &> /dev/null; then
    echo -e "${YELLOW}Installing uv (Python package manager)...${NC}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi
echo -e "${GREEN}✓${NC} uv: $(uv --version)"

# Create directories
echo ""
echo -e "${YELLOW}Setting up directories...${NC}"
mkdir -p "${FACTORY_DIR}"/{hooks,bin,config,node_modules,droids,skills,mission-includes}

# Backup existing files
echo ""
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

# Backup existing files before overwriting
backup_file "${FACTORY_DIR}/AGENTS.md"
backup_file "${FACTORY_DIR}/hooks/droid-speak.sh"
backup_file "${FACTORY_DIR}/hooks/mcp-keyword-detector.py"
backup_file "${FACTORY_DIR}/bin/tts-speak"
backup_file "${FACTORY_DIR}/config/droid-voice-scenarios.json"
backup_file "${FACTORY_DIR}/mcp.json"
backup_dir "${FACTORY_DIR}/droids"
backup_dir "${FACTORY_DIR}/skills"
backup_dir "${FACTORY_DIR}/mission-includes"

if [[ -d "$BACKUP_DIR" ]] && [[ -n "$(ls -A $BACKUP_DIR 2>/dev/null)" ]]; then
    echo -e "${GREEN}✓${NC} Backup created at: ${BACKUP_DIR}"
else
    echo -e "${BLUE}ℹ${NC} No existing files to backup"
fi

# Install edge-tts-universal
echo ""
echo -e "${YELLOW}Installing TTS engine (edge-tts-universal)...${NC}"
cd "${FACTORY_DIR}"
if [[ ! -d "node_modules/edge-tts-universal" ]]; then
    npm init -y 2>/dev/null || true
    npm install edge-tts-universal --save 2>/dev/null
fi
echo -e "${GREEN}✓${NC} edge-tts-universal installed"

# Download files
echo ""
echo -e "${YELLOW}Downloading configuration files...${NC}"

download_file() {
    local path="$1"
    local dest="$2"
    echo -e "  ${BLUE}↓${NC} $path"
    curl -fsSL "${RAW_URL}/${path}" -o "${dest}"
}

# Download all files
download_file "AGENTS.md" "${FACTORY_DIR}/AGENTS.md"
download_file "hooks/droid-speak.sh" "${FACTORY_DIR}/hooks/droid-speak.sh"
download_file "hooks/mcp-keyword-detector.py" "${FACTORY_DIR}/hooks/mcp-keyword-detector.py"
download_file "bin/tts-speak" "${FACTORY_DIR}/bin/tts-speak"
download_file "config/droid-voice-scenarios.json" "${FACTORY_DIR}/config/droid-voice-scenarios.json"
echo -e "  ${BLUE}↓${NC} mcp-servers.example.json (latest)"
download_file "mcp-servers.example.json" "${FACTORY_DIR}/mcp-servers.example.json"
download_file "mission-includes/AGENTS-PERSONAL.md" "${FACTORY_DIR}/mission-includes/AGENTS-PERSONAL.md"

# Make scripts executable
chmod +x "${FACTORY_DIR}/hooks/droid-speak.sh"
chmod +x "${FACTORY_DIR}/bin/tts-speak"

echo -e "${GREEN}✓${NC} All files downloaded"

# Download custom droids
echo ""
echo -e "${YELLOW}Downloading custom droids (21 total)...${NC}"

# BMAD Droids
BMAD_DROIDS=("bmad-a11y" "bmad-architect" "bmad-db-admin" "bmad-dev" "bmad-docs" "bmad-growth" "bmad-init" "bmad-manager" "bmad-master" "bmad-ops" "bmad-perf" "bmad-planner" "bmad-qa" "bmad-security" "bmad-sre" "bmad-tea" "bmad-ux")

for droid in "${BMAD_DROIDS[@]}"; do
    for file in droid.yaml README.md SKILL.md; do
        dest="${FACTORY_DIR}/droids/${droid}/${file}"
        mkdir -p "$(dirname "$dest")"
        curl -fsSL "${RAW_URL}/droids/${droid}/${file}" -o "${dest}" 2>/dev/null || true
    done
    echo -e "  ${BLUE}↓${NC} droids/${droid}/"
done

# Other droids
OTHER_DROIDS=("diagram-architect" "worker" "scrutiny-feature-reviewer" "user-testing-flow-validator")

for droid in "${OTHER_DROIDS[@]}"; do
    for file in *.md droid.yaml README.md SKILL.md; do
        src_path="${RAW_URL}/droids/${droid}/${file}"
        dest="${FACTORY_DIR}/droids/${droid}/${file}"
        mkdir -p "$(dirname "$dest")"
        curl -fsSL "${src_path}" -o "${dest}" 2>/dev/null || true
    done
    echo -e "  ${BLUE}↓${NC} droids/${droid}/"
done

# Standalone droid files
download_file "droids/docs-fetcher.md" "${FACTORY_DIR}/droids/docs-fetcher.md"
download_file "droids/scrutiny-feature-reviewer.md" "${FACTORY_DIR}/droids/scrutiny-feature-reviewer.md"
download_file "droids/user-testing-flow-validator.md" "${FACTORY_DIR}/droids/user-testing-flow-validator.md"
download_file "droids/worker.md" "${FACTORY_DIR}/droids/worker.md"

echo -e "${GREEN}✓${NC} Custom droids downloaded"

# Download skills
echo ""
echo -e "${YELLOW}Downloading skills...${NC}"

SKILLS=(
    "context7-docs/SKILL.md"
    "xlsx-official/SKILL.md"
)

for skill_file in "${SKILLS[@]}"; do
    dest="${FACTORY_DIR}/skills/${skill_file}"
    mkdir -p "$(dirname "$dest")"
    echo -e "  ${BLUE}↓${NC} skills/${skill_file}"
    curl -fsSL "${RAW_URL}/skills/${skill_file}" -o "${dest}"
done

echo -e "${GREEN}✓${NC} Skills downloaded"

# Setup MCP config
echo ""
echo -e "${YELLOW}Setting up MCP configuration...${NC}"
if [[ ! -f "${FACTORY_DIR}/mcp.json" ]]; then
    cp "${FACTORY_DIR}/mcp-servers.example.json" "${FACTORY_DIR}/mcp.json"
    echo -e "${GREEN}✓${NC} Created mcp.json from template"
    echo -e "${YELLOW}⚠${NC}  Remember to add your API keys to ${FACTORY_DIR}/mcp.json:"
    echo "   - YOUR_CONTEXT7_API_KEY → https://context7.com"
    echo "   - YOUR_GITHUB_PAT → https://github.com/settings/tokens"
else
    echo -e "${BLUE}ℹ${NC} mcp.json already exists, keeping it"
fi

# Test TTS
echo ""
echo -e "${YELLOW}Testing TTS...${NC}"
"${FACTORY_DIR}/hooks/droid-speak.sh" "Instalación completada exitosamente" &
sleep 1

# Summary
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              ✅ Installation Complete!                     ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Installed components:"
echo "  • AGENTS.md - Personal instructions"
echo "  • TTS Voice System - droid-speak.sh + edge-tts-universal"
echo "  • MCP Auto-Invoke - Keyword detection for 17+ MCPs (incl. Dart, Firebase)"
echo "  • MCP Servers Template - Pre-configured MCPs (incl. Dart, Firebase)"
echo "  • BMAD Droids - 17 specialized droids (dev, architect, qa, etc.)"
echo "  • Custom Droids - worker, docs-fetcher, scrutiny, user-testing"
echo "  • Skills - context7-docs, xlsx-official"
echo "  • Mission Includes - AGENTS-PERSONAL.md for Factory missions"
echo ""
if [[ -d "$BACKUP_DIR" ]] && [[ -n "$(ls -A $BACKUP_DIR 2>/dev/null)" ]]; then
    echo -e "${BLUE}📦 Backup saved to: ${BACKUP_DIR}${NC}"
    echo ""
fi
echo -e "${YELLOW}For Factory Missions:${NC}"
echo "  Add this line to your mission's AGENTS.md:"
echo "  \`\`\`"
echo "  <!-- Include personal configuration -->"
echo "  See: ~/.factory/mission-includes/AGENTS-PERSONAL.md"
echo "  \`\`\`"
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
echo ""
