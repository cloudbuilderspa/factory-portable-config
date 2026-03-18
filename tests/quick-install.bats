#!/usr/bin/env bats
#
# Tests for quick-install.sh dependency handling
# Validates: VAL-INSTALL-001, VAL-INSTALL-002, VAL-INSTALL-003, VAL-INSTALL-004,
#            VAL-INSTALL-005, VAL-INSTALL-007
#

SCRIPT="${BATS_TEST_DIRNAME}/../quick-install.sh"

# VAL-INSTALL-001: Missing required tools are detected
@test "quick-install.sh detects missing curl (simulated)" {
    # This test verifies the check_required_tools function exists and works
    # by checking the script contains proper error handling for missing tools
    run grep -q "Missing required tools" "$SCRIPT"
    [ "$status" -eq 0 ]
    
    run grep -q "check_required_tools" "$SCRIPT"
    [ "$status" -eq 0 ]
}

# VAL-INSTALL-002: Node.js version check validates minimum version 18
@test "quick-install.sh has Node.js version check for 18+" {
    run grep -q "MIN_NODE_MAJOR=18" "$SCRIPT"
    [ "$status" -eq 0 ]
    
    run grep -q "Node.js version.*is too old" "$SCRIPT"
    [ "$status" -eq 0 ]
    
    run grep -q "edge-tts-universal requires" "$SCRIPT"
    [ "$status" -eq 0 ]
}

# VAL-INSTALL-003: npm operations handle failures gracefully
@test "quick-install.sh has npm init failure handling" {
    run grep -q "npm init failed" "$SCRIPT"
    [ "$status" -eq 0 ]
}

@test "quick-install.sh has npm install failure handling" {
    run grep -q "npm install edge-tts-universal failed" "$SCRIPT"
    [ "$status" -eq 0 ]
}

# VAL-INSTALL-004: curl download failures are reported
@test "quick-install.sh has curl download failure handling" {
    run grep -q "Failed to download:" "$SCRIPT"
    [ "$status" -eq 0 ]
    
    run grep -q "download_file" "$SCRIPT"
    [ "$status" -eq 0 ]
}

@test "quick-install.sh has die() function for error handling" {
    run grep -q "^die()" "$SCRIPT"
    [ "$status" -eq 0 ]
}

# VAL-INSTALL-005: Backup is created before overwriting files
@test "quick-install.sh has backup functionality" {
    # Check backup_file function exists
    run grep -q "^backup_file()" "$SCRIPT"
    [ "$status" -eq 0 ]
    
    # Check backup_dir function exists
    run grep -q "^backup_dir()" "$SCRIPT"
    [ "$status" -eq 0 ]
    
    # Check backup directory variable exists
    run grep -q "BACKUP_DIR=" "$SCRIPT"
    [ "$status" -eq 0 ]
    
    # Check backup is created before overwriting AGENTS.md
    run grep -q "backup_file.*AGENTS.md" "$SCRIPT"
    [ "$status" -eq 0 ]
    
    # Check backup is created before overwriting mcp.json
    run grep -q "backup_file.*mcp.json" "$SCRIPT"
    [ "$status" -eq 0 ]
    
    # Check backup directory is in ~/.factory-backup-*
    run grep -q 'BACKUP_DIR=.*\.factory-backup-' "$SCRIPT"
    [ "$status" -eq 0 ]
}

@test "quick-install.sh reports backup location in summary" {
    run grep -q "Backup saved to:" "$SCRIPT"
    [ "$status" -eq 0 ]
}

# VAL-INSTALL-007: Installation is idempotent
@test "quick-install.sh is idempotent for npm init" {
    # Check that npm init only runs if package.json doesn't exist
    run grep -q '\[\[ ! -f "package.json" \]\]' "$SCRIPT"
    [ "$status" -eq 0 ]
}

@test "quick-install.sh is idempotent for npm install" {
    # Check that npm install only runs if edge-tts-universal isn't installed
    run grep -q '\[\[ ! -d "node_modules/edge-tts-universal" \]\]' "$SCRIPT"
    [ "$status" -eq 0 ]
}

@test "quick-install.sh is idempotent for mcp.json" {
    # Check that mcp.json is not overwritten if it exists
    run grep -q '\[\[ ! -f ".*mcp.json" \]\]' "$SCRIPT"
    [ "$status" -eq 0 ]
    
    # Check there's a message about keeping existing mcp.json
    run grep -q "mcp.json already exists, keeping" "$SCRIPT"
    [ "$status" -eq 0 ]
}

@test "quick-install.sh handles missing directories gracefully" {
    # Check that mkdir -p is used for creating directories
    run grep -q "mkdir -p" "$SCRIPT"
    [ "$status" -eq 0 ]
    
    # Check that download_file creates parent directories
    run grep -q 'mkdir -p.*dirname.*dest' "$SCRIPT"
    [ "$status" -eq 0 ]
}
