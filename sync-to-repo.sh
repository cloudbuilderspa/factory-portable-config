#!/usr/bin/env bash
#
# Sync Factory config to portable repo
# Copies from ~/.factory/ and sanitizes tokens before committing
#
# Usage: 
#   ./sync-to-repo.sh              # Sync only
#   ./sync-to-repo.sh --commit     # Sync and commit
#   ./sync-to-repo.sh --commit --push  # Sync, commit, and push

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPO_DIR="${REPO_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
FACTORY_DIR="${FACTORY_DIR:-${HOME}/.factory}"

echo -e "${BLUE}🔄 Syncing Factory config to portable repo...${NC}"
echo ""

cd "$REPO_DIR"

# Sync AGENTS.md
if [[ -f "${FACTORY_DIR}/AGENTS.md" ]]; then
    cp "${FACTORY_DIR}/AGENTS.md" "${REPO_DIR}/AGENTS.md"
    echo -e "  ${GREEN}✓${NC} AGENTS.md"
fi

# Sync hooks (all .sh and .py files)
if [[ -d "${FACTORY_DIR}/hooks" ]]; then
    mkdir -p "${REPO_DIR}/hooks"
    for file in "${FACTORY_DIR}/hooks"/*; do
        if [[ -f "$file" ]]; then
            cp "$file" "${REPO_DIR}/hooks/"
        fi
    done
    echo -e "  ${GREEN}✓${NC} hooks/"
fi

# Sync bin (all executables)
if [[ -d "${FACTORY_DIR}/bin" ]]; then
    mkdir -p "${REPO_DIR}/bin"
    for file in "${FACTORY_DIR}/bin"/*; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            # Skip binary files and node modules
            case "$filename" in
                *.node|rg|keytar.node) continue ;;
            esac
            cp "$file" "${REPO_DIR}/bin/"
        fi
    done
    echo -e "  ${GREEN}✓${NC} bin/"
fi

# Sync config
if [[ -d "${FACTORY_DIR}/config" ]]; then
    mkdir -p "${REPO_DIR}/config"
    cp -r "${FACTORY_DIR}/config"/* "${REPO_DIR}/config/" 2>/dev/null || true
    echo -e "  ${GREEN}✓${NC} config/"
fi

# Sync skills (all directories)
if [[ -d "${FACTORY_DIR}/skills" ]]; then
    rm -rf "${REPO_DIR}/skills"
    mkdir -p "${REPO_DIR}/skills"
    for dir in "${FACTORY_DIR}/skills"/*; do
        if [[ -d "$dir" ]]; then
            skill_name=$(basename "$dir")
            mkdir -p "${REPO_DIR}/skills/${skill_name}"
            cp -r "$dir"/* "${REPO_DIR}/skills/${skill_name}/" 2>/dev/null || true
        fi
    done
    echo -e "  ${GREEN}✓${NC} skills/"
fi

# Sync droids (all directories and .md files)
if [[ -d "${FACTORY_DIR}/droids" ]]; then
    rm -rf "${REPO_DIR}/droids"
    mkdir -p "${REPO_DIR}/droids"
    # Copy directories
    for dir in "${FACTORY_DIR}/droids"/*; do
        if [[ -d "$dir" ]]; then
            droid_name=$(basename "$dir")
            # Skip _backup and hidden directories
            if [[ "$droid_name" == _* ]] || [[ "$droid_name" == .* ]]; then
                continue
            fi
            mkdir -p "${REPO_DIR}/droids/${droid_name}"
            cp -r "$dir"/* "${REPO_DIR}/droids/${droid_name}/" 2>/dev/null || true
        fi
    done
    # Copy standalone .md files
    for file in "${FACTORY_DIR}/droids"/*.md; do
        if [[ -f "$file" ]]; then
            cp "$file" "${REPO_DIR}/droids/"
        fi
    done
    echo -e "  ${GREEN}✓${NC} droids/"
fi

# Sync mission-includes
if [[ -d "${FACTORY_DIR}/mission-includes" ]]; then
    mkdir -p "${REPO_DIR}/mission-includes"
    cp -r "${FACTORY_DIR}/mission-includes"/* "${REPO_DIR}/mission-includes/" 2>/dev/null || true
    echo -e "  ${GREEN}✓${NC} mission-includes/"
fi

# Sync MCP config (SANITIZE TOKENS)
if [[ -f "${FACTORY_DIR}/mcp.json" ]]; then
    # Sanitize all API keys and tokens
    sed -E '
        # Context7
        s/"CONTEXT7_API_KEY": "[^"]*"/"CONTEXT7_API_KEY": "YOUR_CONTEXT7_API_KEY"/g
        # GitHub
        s/"GITHUB_PERSONAL_ACCESS_TOKEN": "[^"]*"/"GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_GITHUB_PAT"/g
        # Anthropic
        s/"ANTHROPIC_API_KEY": "[^"]*"/"ANTHROPIC_API_KEY": "YOUR_ANTHROPIC_API_KEY"/g
        # OpenAI
        s/"OPENAI_API_KEY": "[^"]*"/"OPENAI_API_KEY": "YOUR_OPENAI_API_KEY"/g
        # Generic patterns
        s/("API_KEY": ")[^"]*(")/\1YOUR_API_KEY\2/g
        s/("SECRET": ")[^"]*(")/\1YOUR_SECRET\2/g
        s/("TOKEN": ")[^"]*(")/\1YOUR_TOKEN\2/g
        s/("PASSWORD": ")[^"]*(")/\1YOUR_PASSWORD\2/g
    ' "${FACTORY_DIR}/mcp.json" > "${REPO_DIR}/mcp-servers.example.json"
    echo -e "  ${GREEN}✓${NC} mcp-servers.example.json (sanitized)"
fi

echo ""
echo -e "${YELLOW}📊 Git status:${NC}"
git status --short

# Commit if requested
if [[ " $* " == *" --commit "* ]] || [[ " $* " == *" -c "* ]]; then
    echo ""
    echo -e "${YELLOW}💾 Committing changes...${NC}"
    git add -A
    
    # Check if there are changes to commit
    if git diff --cached --quiet; then
        echo -e "  ${BLUE}ℹ${NC} No changes to commit"
    else
        git commit -m "Sync from ~/.factory - $(date +%Y-%m-%d)

Co-authored-by: factory-droid[bot] <138933559+factory-droid[bot]@users.noreply.github.com>"
        echo -e "  ${GREEN}✓${NC} Committed"
    fi
fi

# Push if requested
if [[ " $* " == *" --push "* ]] || [[ " $* " == *" -p "* ]]; then
    echo ""
    echo -e "${YELLOW}🚀 Pushing to GitHub...${NC}"
    git push
    echo -e "  ${GREEN}✓${NC} Pushed to origin/main"
fi

echo ""
echo -e "${GREEN}✅ Sync complete!${NC}"

# Show usage hint if no flags
if [[ " $* " != *" --commit "* ]] && [[ " $* " != *" --push "* ]]; then
    echo ""
    echo "To commit: ./sync-to-repo.sh --commit"
    echo "To commit and push: ./sync-to-repo.sh --commit --push"
fi
