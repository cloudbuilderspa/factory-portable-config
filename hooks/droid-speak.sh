#!/usr/bin/env bash
#
# File: ~/.factory/hooks/droid-speak.sh
#
# Droid TTS Voice Integration for Factory
# Maps scenarios to voices and triggers TTS
#
# Usage: droid-speak.sh "dialogue text" [scenario]
#        droid-speak.sh "dialogue text" --auto (auto-detect scenario)
#
# Auto-detects scenario based on keywords if not specified

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Portable config path - use FACTORY_DIR env var or fall back to relative path from script
FACTORY_ROOT="${FACTORY_DIR:-$(dirname "$SCRIPT_DIR")}"
CONFIG_FILE="$FACTORY_ROOT/config/droid-voice-scenarios.json"

# Default voice (Chile - Catalina)
DEFAULT_VOICE="es-CL-CatalinaNeural"

# Get arguments
DIALOGUE="${1:-}"
SCENARIO="${2:-}"

# If no dialogue, show help
if [[ -z "$DIALOGUE" ]]; then
    echo "Usage: droid-speak.sh \"message\" [scenario]"
    echo "       droid-speak.sh \"message\" --auto"
    echo ""
    echo "Scenarios: software_development, cloud_aws, architecture_ia, claude_code, droid_factory, kubernetes, debug, research"
    exit 0
fi

# Auto-detect scenario from dialogue text using keywords
detect_scenario() {
    local text
    text=$(echo "$DIALOGUE" | tr '[:upper:]' '[:lower:]')  # Convert to lowercase for matching
    
    # Software development keywords
    if [[ "$text" =~ (create|edit|refactor|implement|build|write|update|delete|desarroll|código|code) ]]; then
        echo "software_development"
        return
    fi
    
    # AWS/Cloud keywords
    if [[ "$text" =~ (aws|lambda|s3|ec2|dynamodb|serverless|deploy|cloudformation|cdk|cloud|infraestructura|infrastructure) ]]; then
        echo "cloud_aws"
        return
    fi
    
    # AI/Architecture keywords
    if [[ "$text" =~ (agent|prompt|workflow|ai|llm|model|chain|rag|vector|arquitectura|architecture|inteligencia) ]]; then
        echo "architecture_ia"
        return
    fi
    
    # Claude Code keywords
    if [[ "$text" =~ (claude|command|hook|rule|mcp|settings|config|configuración) ]]; then
        echo "claude_code"
        return
    fi
    
    # Droid/Factory keywords
    if [[ "$text" =~ (droid|factory|session|skill|sesión) ]]; then
        echo "droid_factory"
        return
    fi
    
    # Kubernetes keywords
    if [[ "$text" =~ (kubernetes|k8s|docker|container|pod|deployment|service|helm|namespace|contenedor) ]]; then
        echo "kubernetes"
        return
    fi
    
    # Debug keywords
    if [[ "$text" =~ (fix|bug|error|debug|issue|problem|failed|crash|corregí|arreglé|solucioné) ]]; then
        echo "debug"
        return
    fi
    
    # Research keywords
    if [[ "$text" =~ (search|find|research|investigate|look|explore|analyze|review|encontré|investigué|busqué) ]]; then
        echo "research"
        return
    fi
    
    # Default
    echo "default"
}

# Get voice for scenario
get_voice() {
    local scenario="$1"
    
    case "$scenario" in
        software_development)
            echo "es-MX-JorgeNeural"
            ;;
        cloud_aws)
            echo "es-ES-AlvaroNeural"
            ;;
        architecture_ia)
            echo "es-CL-CatalinaNeural"
            ;;
        claude_code)
            echo "es-ES-ElviraNeural"
            ;;
        droid_factory)
            echo "es-AR-ElenaNeural"
            ;;
        kubernetes)
            echo "es-CO-GonzaloNeural"
            ;;
        debug)
            echo "es-AR-TomasNeural"
            ;;
        research)
            echo "es-ES-XimenaNeural"
            ;;
        *)
            echo "$DEFAULT_VOICE"
            ;;
    esac
}

# Determine scenario
if [[ "$SCENARIO" == "--auto" ]] || [[ -z "$SCENARIO" ]]; then
    SCENARIO=$(detect_scenario)
fi

# Get voice for scenario
VOICE=$(get_voice "$SCENARIO")

# Speak using tts-speak (non-blocking with &)
echo "🤖 Droid [$SCENARIO]: $DIALOGUE"

# Check TTS binary exists
if [[ ! -x "$SCRIPT_DIR/../bin/tts-speak" ]]; then
    echo "⚠️  TTS binary not found or not executable: $SCRIPT_DIR/../bin/tts-speak" >&2
    exit 1
fi

# Run TTS in background (non-blocking for user experience)
"$SCRIPT_DIR/../bin/tts-speak" "$DIALOGUE" -v "$VOICE" &
disown 2>/dev/null || true
