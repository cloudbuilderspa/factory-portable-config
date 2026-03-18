#!/usr/bin/env bash
#
# Factory Droid Portable Config - Quick Install Script
# Installs TTS, hooks, MCP config, personal instructions, custom droids, skills, and mission includes
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/cloudbuilderspa/factory-portable-config/main/quick-install.sh | bash
#   ./quick-install.sh --dry-run  # Show what would be done without making changes
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
CYAN='\033[0;36m'
NC='\033[0m'

REPO_URL="https://github.com/cloudbuilderspa/factory-portable-config"
RAW_URL="https://raw.githubusercontent.com/cloudbuilderspa/factory-portable-config/main"
FACTORY_DIR="${HOME}/.factory"
BACKUP_DIR="${HOME}/.factory-backup-$(date +%Y%m%d_%H%M%S)"

# Minimum Node.js version required for edge-tts-universal
MIN_NODE_MAJOR=18

# Parse arguments
DRY_RUN=false
for arg in "$@"; do
    case "$arg" in
        --dry-run|-n)
            DRY_RUN=true
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dry-run, -n    Show what would be done without making changes"
            echo "  --help, -h       Show this help message"
            exit 0
            ;;
    esac
done

# Dry-run helper functions
dry_run_echo() {
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${CYAN}[DRY-RUN]${NC} $1"
    fi
}

dry_run_skip() {
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${CYAN}[DRY-RUN]${NC} Skipping: $1"
        return 0
    fi
    return 1
}

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║     Factory Droid Portable Config - Quick Installer        ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Error handling function
die() {
    echo -e "${RED}❌ ERROR: $1${NC}" >&2
    exit 1
}

# Check for required tools (VAL-INSTALL-001)
check_required_tools() {
    local missing_tools=()
    
    if ! command -v curl &> /dev/null; then
        missing_tools+=("curl")
    fi
    
    if ! command -v git &> /dev/null; then
        missing_tools+=("git")
    fi
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        echo -e "${RED}❌ Missing required tools: ${missing_tools[*]}${NC}" >&2
        echo -e "${YELLOW}Please install the missing tools and try again:${NC}" >&2
        for tool in "${missing_tools[@]}"; do
            case "$tool" in
                curl)
                    echo "  • curl: apt-get install curl (Linux) or brew install curl (macOS)" >&2
                    ;;
                git)
                    echo "  • git: apt-get install git (Linux) or brew install git (macOS)" >&2
                    ;;
            esac
        done
        exit 1
    fi
    
    echo -e "${GREEN}✓${NC} Required tools found (curl, git)"
}

check_required_tools

# Show dry-run mode notice
if [[ "$DRY_RUN" == "true" ]]; then
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    🔍 DRY-RUN MODE                         ║${NC}"
    echo -e "${CYAN}║         No changes will be made to your system            ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
fi

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
echo -e "${YELLOW}Checking dependencies...${NC}"

# Node.js
if ! command -v node &> /dev/null; then
    if dry_run_skip "Installing Node.js"; then
        dry_run_echo "Would install Node.js via Homebrew (macOS) or NodeSource (Linux)"
    else
        echo -e "${YELLOW}Installing Node.js...${NC}"
        if [[ "$OS" == "macos" ]]; then
            brew install node || die "Failed to install Node.js via Homebrew"
        elif [[ "$OS" == "linux" ]]; then
            curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - || die "Failed to add NodeSource repository"
            sudo apt-get install -y nodejs || die "Failed to install Node.js via apt"
        fi
    fi
fi

# Check Node.js version (edge-tts-universal requires 18+) - VAL-INSTALL-002
NODE_VERSION=$(node --version 2>/dev/null | sed 's/v//')
NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d. -f1)
if [[ -z "$NODE_MAJOR" ]] || [[ "$NODE_MAJOR" -lt "$MIN_NODE_MAJOR" ]]; then
    echo -e "${RED}❌ Node.js version $NODE_VERSION is too old. Version ${MIN_NODE_MAJOR}+ is required for edge-tts-universal.${NC}" >&2
    echo -e "${YELLOW}Please upgrade Node.js:${NC}" >&2
    echo "  • Using nvm: nvm install --lts && nvm use --lts" >&2
    echo "  • macOS: brew upgrade node" >&2
    echo "  • Linux: curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs" >&2
    exit 1
fi
echo -e "${GREEN}✓${NC} Node.js: $(node --version) (meets minimum requirement v${MIN_NODE_MAJOR})"

# ffmpeg
if ! command -v ffmpeg &> /dev/null; then
    if dry_run_skip "Installing ffmpeg"; then
        dry_run_echo "Would install ffmpeg via Homebrew (macOS) or apt-get (Linux)"
    else
        echo -e "${YELLOW}Installing ffmpeg...${NC}"
        if [[ "$OS" == "macos" ]]; then
            brew install ffmpeg
        elif [[ "$OS" == "linux" ]]; then
            sudo apt-get install -y ffmpeg
        fi
    fi
else
    echo -e "${GREEN}✓${NC} ffmpeg: $(ffmpeg -version | head -1 | cut -d' ' -f3)"
fi

# uv (for AWS MCPs)
if ! command -v uv &> /dev/null; then
    if dry_run_skip "Installing uv (Python package manager)"; then
        dry_run_echo "Would install uv via astral.sh installer"
    else
        echo -e "${YELLOW}Installing uv (Python package manager)...${NC}"
        curl -LsSf https://astral.sh/uv/install.sh | sh
        export PATH="$HOME/.local/bin:$PATH"
    fi
else
    echo -e "${GREEN}✓${NC} uv: $(uv --version)"
fi

# Create directories
echo ""
echo -e "${YELLOW}Setting up directories...${NC}"
if dry_run_skip "Creating directory structure"; then
    dry_run_echo "Would create: ${FACTORY_DIR}/{hooks,bin,config,node_modules,droids,skills,mission-includes}"
else
    mkdir -p "${FACTORY_DIR}"/{hooks,bin,config,node_modules,droids,skills,mission-includes}
fi

# Backup existing files
echo ""
echo -e "${YELLOW}Creating backup of existing files...${NC}"

backup_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            local rel_path="${file#$FACTORY_DIR/}"
            dry_run_echo "Would backup: $rel_path → ${BACKUP_DIR}/${rel_path}"
        else
            local rel_path="${file#$FACTORY_DIR/}"
            local backup_path="${BACKUP_DIR}/${rel_path}"
            mkdir -p "$(dirname "$backup_path")"
            cp "$file" "$backup_path"
            echo -e "  ${BLUE}↩${NC} Backed up: $rel_path"
        fi
    fi
}

backup_dir() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            local rel_path="${dir#$FACTORY_DIR/}"
            dry_run_echo "Would backup: $rel_path/ → ${BACKUP_DIR}/${rel_path}/"
        else
            local rel_path="${dir#$FACTORY_DIR/}"
            local backup_path="${BACKUP_DIR}/${rel_path}"
            mkdir -p "$backup_path"
            cp -r "$dir"/* "$backup_path"/ 2>/dev/null || true
            echo -e "  ${BLUE}↩${NC} Backed up: $rel_path/"
        fi
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

if [[ "$DRY_RUN" != "true" ]]; then
    if [[ -d "$BACKUP_DIR" ]] && [[ -n "$(ls -A $BACKUP_DIR 2>/dev/null)" ]]; then
        echo -e "${GREEN}✓${NC} Backup created at: ${BACKUP_DIR}"
    else
        echo -e "${BLUE}ℹ${NC} No existing files to backup"
    fi
fi

# Install edge-tts-universal
echo ""
echo -e "${YELLOW}Installing TTS engine (edge-tts-universal)...${NC}"
if [[ "$DRY_RUN" == "true" ]]; then
    if [[ ! -d "${FACTORY_DIR}/node_modules/edge-tts-universal" ]]; then
        dry_run_echo "Would initialize npm package in ${FACTORY_DIR}"
        dry_run_echo "Would install edge-tts-universal via npm"
    else
        dry_run_echo "edge-tts-universal already installed, would skip"
    fi
else
    cd "${FACTORY_DIR}"
    if [[ ! -d "node_modules/edge-tts-universal" ]]; then
        # Initialize npm if package.json doesn't exist - VAL-INSTALL-003
        if [[ ! -f "package.json" ]]; then
            echo -e "  ${BLUE}→${NC} Initializing npm package..."
            if ! npm init -y 2>/dev/null; then
                die "npm init failed. Check npm permissions and try again."
            fi
        fi
        # Install edge-tts-universal - VAL-INSTALL-003
        echo -e "  ${BLUE}→${NC} Installing edge-tts-universal..."
        if ! npm install edge-tts-universal --save 2>&1; then
            die "npm install edge-tts-universal failed. Check network connection and npm permissions."
        fi
    fi
    echo -e "${GREEN}✓${NC} edge-tts-universal installed"
fi

# Download files
echo ""
echo -e "${YELLOW}Downloading configuration files...${NC}"

download_file() {
    local path="$1"
    local dest="$2"
    local url="${RAW_URL}/${path}"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        dry_run_echo "Would download: $path → ${dest}"
        return 0
    fi
    
    # Create parent directory if it doesn't exist (handles missing directories)
    mkdir -p "$(dirname "$dest")"
    
    echo -e "  ${BLUE}↓${NC} $path"
    if ! curl -fsSL "$url" -o "${dest}" 2>/dev/null; then
        echo -e "${RED}❌ Failed to download: $path${NC}" >&2
        echo -e "${YELLOW}   URL: $url${NC}" >&2
        echo -e "${YELLOW}   This may be a network issue or the file may not exist in the repository.${NC}" >&2
        # Don't exit on download failure for optional files, just warn
        return 1
    fi
    return 0
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
if [[ "$DRY_RUN" == "true" ]]; then
    dry_run_echo "Would make scripts executable: droid-speak.sh, tts-speak"
else
    chmod +x "${FACTORY_DIR}/hooks/droid-speak.sh"
    chmod +x "${FACTORY_DIR}/bin/tts-speak"
fi

if [[ "$DRY_RUN" != "true" ]]; then
    echo -e "${GREEN}✓${NC} All files downloaded"
fi

# Download custom droids
echo ""
echo -e "${YELLOW}Downloading custom droids (21 total)...${NC}"

# BMAD Droids
BMAD_DROIDS=("bmad-a11y" "bmad-architect" "bmad-db-admin" "bmad-dev" "bmad-docs" "bmad-growth" "bmad-init" "bmad-manager" "bmad-master" "bmad-ops" "bmad-perf" "bmad-planner" "bmad-qa" "bmad-security" "bmad-sre" "bmad-tea" "bmad-ux")

for droid in "${BMAD_DROIDS[@]}"; do
    if [[ "$DRY_RUN" == "true" ]]; then
        dry_run_echo "Would download: droids/${droid}/"
    else
        for file in droid.yaml README.md SKILL.md; do
            dest="${FACTORY_DIR}/droids/${droid}/${file}"
            mkdir -p "$(dirname "$dest")"
            curl -fsSL "${RAW_URL}/droids/${droid}/${file}" -o "${dest}" 2>/dev/null || true
        done
        echo -e "  ${BLUE}↓${NC} droids/${droid}/"
    fi
done

# Other droids
OTHER_DROIDS=("diagram-architect" "worker" "scrutiny-feature-reviewer" "user-testing-flow-validator")

for droid in "${OTHER_DROIDS[@]}"; do
    if [[ "$DRY_RUN" == "true" ]]; then
        dry_run_echo "Would download: droids/${droid}/"
    else
        for file in *.md droid.yaml README.md SKILL.md; do
            src_path="${RAW_URL}/droids/${droid}/${file}"
            dest="${FACTORY_DIR}/droids/${droid}/${file}"
            mkdir -p "$(dirname "$dest")"
            curl -fsSL "${src_path}" -o "${dest}" 2>/dev/null || true
        done
        echo -e "  ${BLUE}↓${NC} droids/${droid}/"
    fi
done

# Standalone droid files
download_file "droids/docs-fetcher.md" "${FACTORY_DIR}/droids/docs-fetcher.md"
download_file "droids/scrutiny-feature-reviewer.md" "${FACTORY_DIR}/droids/scrutiny-feature-reviewer.md"
download_file "droids/user-testing-flow-validator.md" "${FACTORY_DIR}/droids/user-testing-flow-validator.md"
download_file "droids/worker.md" "${FACTORY_DIR}/droids/worker.md"

if [[ "$DRY_RUN" != "true" ]]; then
    echo -e "${GREEN}✓${NC} Custom droids downloaded"
fi

# Download skills
echo ""
echo -e "${YELLOW}Downloading skills...${NC}"

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
    if [[ "$DRY_RUN" == "true" ]]; then
        dry_run_echo "Would download: skills/${skill_file}"
    else
        dest="${FACTORY_DIR}/skills/${skill_file}"
        mkdir -p "$(dirname "$dest")"
        echo -e "  ${BLUE}↓${NC} skills/${skill_file}"
        curl -fsSL "${RAW_URL}/skills/${skill_file}" -o "${dest}"
    fi
done

if [[ "$DRY_RUN" != "true" ]]; then
    echo -e "${GREEN}✓${NC} Skills downloaded"
fi

# Setup MCP config
echo ""
echo -e "${YELLOW}Setting up MCP configuration...${NC}"
if [[ "$DRY_RUN" == "true" ]]; then
    if [[ ! -f "${FACTORY_DIR}/mcp.json" ]]; then
        dry_run_echo "Would create mcp.json from template"
    else
        dry_run_echo "mcp.json already exists, would keep it"
    fi
else
    if [[ ! -f "${FACTORY_DIR}/mcp.json" ]]; then
        cp "${FACTORY_DIR}/mcp-servers.example.json" "${FACTORY_DIR}/mcp.json"
        echo -e "${GREEN}✓${NC} Created mcp.json from template"
        echo -e "${YELLOW}⚠${NC}  Remember to add your API keys to ${FACTORY_DIR}/mcp.json:"
        echo "   - YOUR_CONTEXT7_API_KEY → https://context7.com"
        echo "   - YOUR_GITHUB_PAT → https://github.com/settings/tokens"
    else
        echo -e "${BLUE}ℹ${NC} mcp.json already exists, keeping it"
    fi
fi

# Test TTS
echo ""
echo -e "${YELLOW}Testing TTS...${NC}"
if [[ "$DRY_RUN" == "true" ]]; then
    dry_run_echo "Would test TTS with: 'Instalación completada exitosamente'"
else
    # Run TTS and validate success
    TTS_TEST_MSG="Instalación completada exitosamente"
    if "${FACTORY_DIR}/hooks/droid-speak.sh" "$TTS_TEST_MSG" 2>&1 | grep -q "Droid"; then
        echo -e "${GREEN}✅ TTS test passed${NC}"
    else
        echo -e "${RED}❌ TTS test failed. Check that edge-tts-universal is installed.${NC}"
    fi
fi

# Summary
echo ""
if [[ "$DRY_RUN" == "true" ]]; then
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              🔍 DRY-RUN COMPLETE - SUMMARY                ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Planned actions:"
    echo "  • Install dependencies (Node.js, ffmpeg, uv) if missing"
    echo "  • Create directory structure in ${FACTORY_DIR}"
    echo "  • Backup existing files to ${BACKUP_DIR}"
    echo "  • Initialize npm and install edge-tts-universal"
    echo "  • Download configuration files (AGENTS.md, hooks, bin)"
    echo "  • Download 21 custom droids"
    echo "  • Download 28 skills"
    echo "  • Create mcp.json from template (if not exists)"
    echo "  • Test TTS system"
    echo ""
    echo -e "${GREEN}✅ No changes were made to your system${NC}"
else
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
    echo "  • Skills - official Vercel skills + context7-docs + xlsx-official"
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
fi
