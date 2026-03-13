#!/usr/bin/env bats

setup() {
  SCRIPT="${BATS_TEST_DIRNAME}/../sync-to-repo.sh"
  TMP_ROOT="$(mktemp -d)"
  REPO_DIR="${TMP_ROOT}/repo"
  FACTORY_DIR="${TMP_ROOT}/factory"
  mkdir -p "$REPO_DIR" "$FACTORY_DIR"
  git -C "$REPO_DIR" init -q
  cat > "${FACTORY_DIR}/mcp.json" <<'EOF'
{
  "mcpServers": {
    "context7": {
      "env": {
        "CONTEXT7_API_KEY": "ctx7-secret"
      }
    },
    "github": {
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_secret"
      }
    }
  },
  "ANTHROPIC_API_KEY": "anthropic-secret",
  "OPENAI_API_KEY": "openai-secret",
  "API_KEY": "generic-api-key",
  "SECRET": "generic-secret",
  "TOKEN": "generic-token",
  "PASSWORD": "generic-password"
}
EOF
}

teardown() {
  rm -rf "$TMP_ROOT"
}

@test "sync-to-repo sanitizes mcp.json tokens" {
  run env FACTORY_DIR="$FACTORY_DIR" REPO_DIR="$REPO_DIR" "$SCRIPT"
  [ "$status" -eq 0 ]
  [ -f "${REPO_DIR}/mcp-servers.example.json" ]

  grep -q 'YOUR_CONTEXT7_API_KEY' "${REPO_DIR}/mcp-servers.example.json"
  grep -q 'YOUR_GITHUB_PAT' "${REPO_DIR}/mcp-servers.example.json"
  grep -q 'YOUR_ANTHROPIC_API_KEY' "${REPO_DIR}/mcp-servers.example.json"
  grep -q 'YOUR_OPENAI_API_KEY' "${REPO_DIR}/mcp-servers.example.json"
  grep -q 'YOUR_API_KEY' "${REPO_DIR}/mcp-servers.example.json"
  grep -q 'YOUR_SECRET' "${REPO_DIR}/mcp-servers.example.json"
  grep -q 'YOUR_TOKEN' "${REPO_DIR}/mcp-servers.example.json"
  grep -q 'YOUR_PASSWORD' "${REPO_DIR}/mcp-servers.example.json"

  if grep -q 'ctx7-secret' "${REPO_DIR}/mcp-servers.example.json"; then
    false
  fi
  if grep -q 'ghp_secret' "${REPO_DIR}/mcp-servers.example.json"; then
    false
  fi
  if grep -q 'anthropic-secret' "${REPO_DIR}/mcp-servers.example.json"; then
    false
  fi
  if grep -q 'openai-secret' "${REPO_DIR}/mcp-servers.example.json"; then
    false
  fi
  if grep -q 'generic-api-key' "${REPO_DIR}/mcp-servers.example.json"; then
    false
  fi
  if grep -q 'generic-secret' "${REPO_DIR}/mcp-servers.example.json"; then
    false
  fi
  if grep -q 'generic-token' "${REPO_DIR}/mcp-servers.example.json"; then
    false
  fi
  if grep -q 'generic-password' "${REPO_DIR}/mcp-servers.example.json"; then
    false
  fi
}
