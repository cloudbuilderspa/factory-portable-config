#!/usr/bin/env bash
#
# File: /Users/asuresky/.factory/hooks/droid-speak.sh
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
CONFIG_FILE="/Users/asuresky/.factory/config/droid-voice-scenarios.json"

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

# Auto-detect scenario from environment or context
detect_scenario() {
    local context="${LAST_TASK:-${CONTEXT:-}}"
    
    # Check config file for keywords
    if [[ -f "$CONFIG_FILE" ]]; then
        for scenario in software_development cloud_aws architecture_ia claude_code droid_factory kubernetes debug research; do
            if grep -q "\"$scenario\"" "$CONFIG_FILE" 2>/dev/null; then
                case "$scenario" in
                    software_development)
                        echo "software_development" ;;
                    cloud_aws)
                        echo "cloud_aws" ;;
                    architecture_ia)
                        echo "architecture_ia" ;;
                    claude_code)
                        echo "claude_code" ;;
                    droid_factory)
                        echo "droid_factory" ;;
                    kubernetes)
                        echo "kubernetes" ;;
                    debug)
                        echo "debug" ;;
                    research)
                        echo "research" ;;
                esac
                return
            fi
        done
    fi
    
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
"$SCRIPT_DIR/../bin/tts-speak" "$DIALOGUE" -v "$VOICE" &
