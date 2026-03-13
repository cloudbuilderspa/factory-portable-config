#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if command -v bats >/dev/null 2>&1; then
  exec bats -r "${ROOT_DIR}/tests"
fi

if command -v npx >/dev/null 2>&1; then
  exec npx --yes bats -r "${ROOT_DIR}/tests"
fi

echo "Error: bats-core is not installed and npx is unavailable." >&2
echo "Install bats (https://github.com/bats-core/bats-core) or ensure npx is available." >&2
exit 1
