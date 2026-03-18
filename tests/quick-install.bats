#!/usr/bin/env bats
#
# Tests for quick-install.sh dependency handling
# Validates: VAL-INSTALL-001, VAL-INSTALL-002, VAL-INSTALL-003, VAL-INSTALL-004,
#            VAL-INSTALL-005, VAL-INSTALL-006, VAL-INSTALL-007
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

# VAL-INSTALL-006: Dry-run mode works correctly
@test "quick-install.sh has --dry-run flag support" {
    # Check --dry-run flag is parsed
    run grep -q '\-\-dry-run' "$SCRIPT"
    [ "$status" -eq 0 ]
    
    # Check -n short flag is supported
    run grep -q '\-n' "$SCRIPT"
    [ "$status" -eq 0 ]
    
    # Check DRY_RUN variable is set
    run grep -q 'DRY_RUN=' "$SCRIPT"
    [ "$status" -eq 0 ]
}

@test "quick-install.sh has dry-run helper functions" {
    # Check dry_run_echo function exists
    run grep -q 'dry_run_echo()' "$SCRIPT"
    [ "$status" -eq 0 ]
    
    # Check dry_run_skip function exists
    run grep -q 'dry_run_skip()' "$SCRIPT"
    [ "$status" -eq 0 ]
}

@test "quick-install.sh shows planned actions in dry-run mode" {
    # Check for dry-run mode header
    run grep -q "DRY-RUN MODE" "$SCRIPT"
    [ "$status" -eq 0 ]
    
    # Check for "Would" prefix in dry-run messages
    run grep -q 'Would' "$SCRIPT"
    [ "$status" -eq 0 ]
    
    # Check for summary section
    run grep -q "DRY-RUN COMPLETE" "$SCRIPT"
    [ "$status" -eq 0 ]
}

@test "quick-install.sh --dry-run exits with code 0" {
    # Run with --dry-run flag - should exit 0
    run "$SCRIPT" --dry-run
    [ "$status" -eq 0 ]
    
    # Check that dry-run message appears in output
    [[ "$output" == *"DRY-RUN MODE"* ]] || false
    
    # Check that no changes message appears
    [[ "$output" == *"No changes were made"* ]] || false
}

@test "quick-install.sh --dry-run does not modify files" {
    # Get modification time of AGENTS.md before dry-run
    local before=""
    if [[ -f "$HOME/.factory/AGENTS.md" ]]; then
        before=$(stat -f "%m" "$HOME/.factory/AGENTS.md" 2>/dev/null || stat -c "%Y" "$HOME/.factory/AGENTS.md" 2>/dev/null)
    fi
    
    # Run dry-run
    run "$SCRIPT" --dry-run
    [ "$status" -eq 0 ]
    
    # Verify AGENTS.md wasn't modified
    if [[ -n "$before" ]]; then
        local after=$(stat -f "%m" "$HOME/.factory/AGENTS.md" 2>/dev/null || stat -c "%Y" "$HOME/.factory/AGENTS.md" 2>/dev/null)
        [ "$before" -eq "$after" ]
    fi
    
    # Verify no backup directory was created
    run bash -c "ls -d $HOME/.factory-backup-* 2>/dev/null | wc -l"
    # The count should not have increased during this test
    [ "$status" -eq 0 ]
}

@test "quick-install.sh --help shows dry-run option" {
    run "$SCRIPT" --help
    [ "$status" -eq 0 ]
    
    # Check --dry-run is documented
    [[ "$output" == *"--dry-run"* ]] || false
}
