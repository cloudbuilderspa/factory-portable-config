#!/usr/bin/env bash
# Factory Portable Config - Init Script
# Runs at start of each worker session

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FACTORY_DIR="${HOME}/.factory"

echo "Initializing factory-portable-config..."

# Check dependencies
for cmd in bash curl git; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: $cmd is required but not installed"
        exit 1
    fi
done

echo "Dependencies OK"
