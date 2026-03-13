#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

coverage_mode=false

for arg in "$@"; do
  case "${arg}" in
    --coverage)
      coverage_mode=true
      ;;
    *)
      echo "Error: Unknown argument '${arg}'." >&2
      echo "Usage: $0 [--coverage]" >&2
      exit 1
      ;;
  esac
done

if "${coverage_mode}"; then
  if ! command -v kcov >/dev/null 2>&1; then
    echo "Error: kcov is required for coverage mode." >&2
    echo "Install kcov (e.g., 'brew install kcov') and try again." >&2
    exit 1
  fi

  if command -v bats >/dev/null 2>&1; then
    exec kcov --exclude-pattern="${ROOT_DIR}/tests" "${ROOT_DIR}/coverage" bats -r "${ROOT_DIR}/tests"
  fi

  if command -v npx >/dev/null 2>&1; then
    exec kcov --exclude-pattern="${ROOT_DIR}/tests" "${ROOT_DIR}/coverage" npx --yes bats -r "${ROOT_DIR}/tests"
  fi

  echo "Error: bats-core is not installed and npx is unavailable." >&2
  echo "Install bats (https://github.com/bats-core/bats-core) or ensure npx is available." >&2
  exit 1
fi

if command -v bats >/dev/null 2>&1; then
  exec bats -r "${ROOT_DIR}/tests"
fi

if command -v npx >/dev/null 2>&1; then
  exec npx --yes bats -r "${ROOT_DIR}/tests"
fi

echo "Error: bats-core is not installed and npx is unavailable." >&2
echo "Install bats (https://github.com/bats-core/bats-core) or ensure npx is available." >&2
exit 1
