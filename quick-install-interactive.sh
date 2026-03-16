#!/usr/bin/env bash
#
# Factory Droid Portable Config - Interactive Quick Install
# Select what to install via menu
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/cloudbuilderspa/factory-portable-config/main/quick-install-interactive.sh | bash
#

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

REPO_URL="https://github.com/cloudbuilderspa/factory-portable-config"
RAW_URL="https://raw.githubusercontent.com/cloudbuilderspa/factory-portable-config/main"
FACTORY_DIR="${HOME}/.factory"
DRY_RUN=false
SELF_TEST=false
SELECTIONS=""


echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║     Factory Droid - Interactive Installer                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

while (( "$#" )); do
    case "$1" in
        --dry-run|--no-install)
            DRY_RUN=true
            shift
            ;;
        --self-test)
            SELF_TEST=true
            shift
            ;;
        --selections)
            SELECTIONS="${2:-}"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# Menu options
options=(
    "AGENTS.md (Personal instructions)"
    "TTS Voice System (hooks + bin + config)"
    "MCP Auto-Invoke Hook"
    "MCP Servers Template"
    "Skills (official Vercel)"
    "BMAD Droids (17 droids)"
    "Custom Droids (worker, docs-fetcher, etc.)"
    "Mission Includes (AGENTS-PERSONAL.md)"
    "ALL (Install everything)"
    "QUIT"
)

parse_selections() {
    local input="$1"
    local -a selected
    local IFS=','

    read -ra parts <<< "$input"
    for part in "${parts[@]}"; do
        part=$(echo "$part" | tr -d ' ')
        if [[ "$part" =~ ^[0-9]+$ ]] && [[ "$part" -ge 1 ]] && [[ "$part" -le ${#options[@]} ]]; then
            selected+=("$((part-1))")
        fi
    done

    echo "${selected[@]}"
}

if [[ "$SELF_TEST" == "true" ]]; then
    test_input="1,3,5"
    parsed="$(parse_selections "$test_input")"
    if [[ "$parsed" == "0 2 4" ]]; then
        echo "Self-test OK: '$test_input' -> [$parsed]"
        exit 0
    fi
    echo "Self-test FAILED: '$test_input' -> [$parsed]"
    exit 1
fi

# Check if Factory CLI is installed (skip in dry-run)
if [[ "$DRY_RUN" != "true" ]] && ! command -v droid &> /dev/null; then
    echo -e "${RED}❌ Factory CLI not found. Please install it first:${NC}"
    echo "   npm install -g @factory/cli"
    exit 1
fi

# Display menu
echo -e "${BOLD}Select components to install:${NC}"
echo ""
for i in "${!options[@]}"; do
    printf "  ${CYAN}%2d)${NC} %s\n" "$((i+1))" "${options[$i]}"
done
echo ""

# Get selections
selections=""
if [[ -n "$SELECTIONS" ]]; then
    selections="$SELECTIONS"
else
    echo -e "${YELLOW}Enter selections (comma-separated, e.g., 1,3,5):${NC} "
    if [[ -t 0 ]]; then
        read -r selections
    else
        read -r selections </dev/tty
    fi
fi

# Parse selections
selected=()
read -ra selected <<< "$(parse_selections "$selections")"

# Handle "ALL" option
if printf '%s\n' "${selected[@]}" | grep -q "^8$"; then
    selected=(0 1 2 3 4 5 6 7)
fi

# Handle "QUIT" option  
if printf '%s\n' "${selected[@]}" | grep -q "^9$"; then
    echo -e "${BLUE}Cancelled.${NC}"
    exit 0
fi

if [[ ${#selected[@]} -eq 0 ]]; then
    echo -e "${RED}No valid selections. Exiting.${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Will install:${NC}"
for idx in "${selected[@]}"; do
    echo -e "  ${GREEN}•${NC} ${options[$idx]}"
done
echo ""

# Confirm
echo -e "${YELLOW}Proceed? [Y/n]${NC}"
if [[ -t 0 ]]; then
    read -r confirm || confirm=""
else
    confirm="y"
fi
if [[ "$confirm" =~ ^[Nn]$ ]]; then
    echo -e "${BLUE}Cancelled.${NC}"
    exit 0
fi

if [[ "$DRY_RUN" == "true" ]]; then
    echo -e "${BLUE}Dry-run mode: skipping installs and downloads.${NC}"
    exit 0
fi

# Create directories
mkdir -p "${FACTORY_DIR}"/{hooks,bin,config,droids,skills,mission-includes}

download_file() {
    local path="$1"
    local dest="$2"
    curl -fsSL "${RAW_URL}/${path}" -o "${dest}" 2>/dev/null
}

# Install selected components
echo ""
echo -e "${CYAN}Installing selected components...${NC}"

# Check if TTS is selected (needs dependencies)
need_tts=false
for idx in "${selected[@]}"; do
    if [[ "$idx" -eq 1 ]]; then
        need_tts=true
    fi
done

if [[ "$need_tts" == "true" ]]; then
    # Check/install Node.js
    if ! command -v node &> /dev/null; then
        echo -e "${YELLOW}Installing Node.js...${NC}"
        if [[ "$(uname -s)" == "Darwin" ]]; then
            brew install node
        else
            curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
            sudo apt-get install -y nodejs
        fi
    fi
    echo -e "  ${GREEN}✓${NC} Node.js: $(node --version)"
    
    # Check/install ffmpeg
    if ! command -v ffmpeg &> /dev/null; then
        echo -e "${YELLOW}Installing ffmpeg...${NC}"
        if [[ "$(uname -s)" == "Darwin" ]]; then
            brew install ffmpeg
        else
            sudo apt-get install -y ffmpeg
        fi
    fi
    echo -e "  ${GREEN}✓${NC} ffmpeg installed"
    
    # Install edge-tts-universal
    echo -e "${YELLOW}Installing TTS engine...${NC}"
    cd "${FACTORY_DIR}"
    if [[ ! -d "node_modules/edge-tts-universal" ]]; then
        npm init -y 2>/dev/null || true
        npm install edge-tts-universal --save 2>/dev/null
    fi
    echo -e "  ${GREEN}✓${NC} edge-tts-universal installed"
fi

# Install each selected component
for idx in "${selected[@]}"; do
    case $idx in
        0) # AGENTS.md
            echo -e "${YELLOW}Installing AGENTS.md...${NC}"
            download_file "AGENTS.md" "${FACTORY_DIR}/AGENTS.md"
            echo -e "  ${GREEN}✓${NC} AGENTS.md installed"
            ;;
        1) # TTS Voice System
            echo -e "${YELLOW}Installing TTS Voice System...${NC}"
            download_file "hooks/droid-speak.sh" "${FACTORY_DIR}/hooks/droid-speak.sh"
            download_file "bin/tts-speak" "${FACTORY_DIR}/bin/tts-speak"
            download_file "config/droid-voice-scenarios.json" "${FACTORY_DIR}/config/droid-voice-scenarios.json"
            chmod +x "${FACTORY_DIR}/hooks/droid-speak.sh"
            chmod +x "${FACTORY_DIR}/bin/tts-speak"
            echo -e "  ${GREEN}✓${NC} TTS Voice System installed"
            ;;
        2) # MCP Auto-Invoke Hook
            echo -e "${YELLOW}Installing MCP Auto-Invoke Hook...${NC}"
            download_file "hooks/mcp-keyword-detector.py" "${FACTORY_DIR}/hooks/mcp-keyword-detector.py"
            echo -e "  ${GREEN}✓${NC} MCP Auto-Invoke Hook installed"
            ;;
        3) # MCP Servers Template
            echo -e "${YELLOW}Installing MCP Servers Template...${NC}"
            download_file "mcp-servers.example.json" "${FACTORY_DIR}/mcp-servers.example.json"
            if [[ ! -f "${FACTORY_DIR}/mcp.json" ]]; then
                cp "${FACTORY_DIR}/mcp-servers.example.json" "${FACTORY_DIR}/mcp.json"
                echo -e "  ${GREEN}✓${NC} Created mcp.json from template"
                echo -e "  ${YELLOW}⚠${NC}  Add your API keys to mcp.json!"
            else
                echo -e "  ${GREEN}✓${NC} Template downloaded (mcp.json already exists)"
            fi
            ;;
        4) # Skills
            echo -e "${YELLOW}Installing Skills...${NC}"
            SKILLS=(
                "context7-docs/SKILL.md"
                "xlsx-official/SKILL.md"
                "vercel-react-best-practices/SKILL.md"
                "vercel-composition-patterns/SKILL.md"
                "vercel-react-native-skills/SKILL.md"
                "web-design-guidelines/SKILL.md"
                "vercel-deploy/SKILL.md"
                "next-best-practices/SKILL.md"
                "next-cache-components/SKILL.md"
                "next-upgrade/SKILL.md"
                "cra-to-next-migration/SKILL.md"
                "turborepo/SKILL.md"
                "ai-sdk/SKILL.md"
                "ai-elements/SKILL.md"
                "streamdown/SKILL.md"
                "building-components/SKILL.md"
                "agent-browser/SKILL.md"
                "vercel-cli/SKILL.md"
                "autoship/SKILL.md"
                "ucp/SKILL.md"
                "workflow/SKILL.md"
                "json-render-core/SKILL.md"
                "json-render-react/SKILL.md"
                "json-render-react-native/SKILL.md"
                "json-render-remotion/SKILL.md"
                "remotion-best-practices/SKILL.md"
                "find-skills/SKILL.md"
                "before-and-after/SKILL.md"
            )

            for skill_file in "${SKILLS[@]}"; do
                dest="${FACTORY_DIR}/skills/${skill_file}"
                mkdir -p "$(dirname "$dest")"
                download_file "skills/${skill_file}" "$dest"
            done
            echo -e "  ${GREEN}✓${NC} Skills installed (official Vercel + context7-docs + xlsx-official)"
            ;;
        5) # BMAD Droids
            echo -e "${YELLOW}Installing BMAD Droids (17)...${NC}"
            BMAD_DROIDS=("bmad-a11y" "bmad-architect" "bmad-db-admin" "bmad-dev" "bmad-docs" "bmad-growth" "bmad-init" "bmad-manager" "bmad-master" "bmad-ops" "bmad-perf" "bmad-planner" "bmad-qa" "bmad-security" "bmad-sre" "bmad-tea" "bmad-ux")
            for droid in "${BMAD_DROIDS[@]}"; do
                mkdir -p "${FACTORY_DIR}/droids/${droid}"
                for file in droid.yaml README.md SKILL.md; do
                    download_file "droids/${droid}/${file}" "${FACTORY_DIR}/droids/${droid}/${file}"
                done
            done
            echo -e "  ${GREEN}✓${NC} BMAD Droids installed (17)"
            ;;
        6) # Custom Droids
            echo -e "${YELLOW}Installing Custom Droids...${NC}"
            for droid in worker docs-fetcher scrutiny-feature-reviewer user-testing-flow-validator diagram-architect; do
                mkdir -p "${FACTORY_DIR}/droids/${droid}"
                download_file "droids/${droid}/${droid}.md" "${FACTORY_DIR}/droids/${droid}/${droid}.md" 2>/dev/null || true
                download_file "droids/${droid}/README.md" "${FACTORY_DIR}/droids/${droid}/README.md" 2>/dev/null || true
            done
            download_file "droids/worker.md" "${FACTORY_DIR}/droids/worker.md"
            download_file "droids/docs-fetcher.md" "${FACTORY_DIR}/droids/docs-fetcher.md"
            echo -e "  ${GREEN}✓${NC} Custom Droids installed"
            ;;
        7) # Mission Includes
            echo -e "${YELLOW}Installing Mission Includes...${NC}"
            mkdir -p "${FACTORY_DIR}/mission-includes"
            download_file "mission-includes/AGENTS-PERSONAL.md" "${FACTORY_DIR}/mission-includes/AGENTS-PERSONAL.md"
            echo -e "  ${GREEN}✓${NC} Mission Includes installed"
            ;;
    esac
done

# Test TTS if installed
if [[ "$need_tts" == "true" ]]; then
    echo ""
    echo -e "${YELLOW}Testing TTS...${NC}"
    "${FACTORY_DIR}/hooks/droid-speak.sh" "Instalación completada" &
    sleep 1
fi

# Summary
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              ✅ Installation Complete!                     ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Installed:${NC}"
for idx in "${selected[@]}"; do
    echo -e "  ${GREEN}•${NC} ${options[$idx]}"
done
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Restart any active Droid sessions"
echo "  2. Add API keys to ~/.factory/mcp.json if needed"
echo ""
