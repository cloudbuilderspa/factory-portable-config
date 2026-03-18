# Bugs Found in Factory Portable Config

This document tracks all bugs discovered during code review.

## Critical Bugs (Must Fix)

### 1. No error handling after dependency installation
- **Files**: quick-install.sh, quick-install-interactive.sh
- **Issue**: Dependencies installed without checking if installation succeeded
- **Fix**: Add version checks and exit on failure

### 2. Silent curl failures
- **Files**: quick-install.sh, quick-install-interactive.sh
- **Issue**: download_file() uses `curl -fsSL` without error handling
- **Fix**: Add error handling to download_file function

### 3. Hardcoded config file path
- **File**: hooks/droid-speak.sh line 31
- **Issue**: `CONFIG_FILE="/Users/asuresky/.factory/config/droid-voice-scenarios.json"` hardcoded
- **Fix**: Use `${FACTORY_DIR:-${HOME}/.factory}` or relative path

### 4. TTS test doesn't check success
- **Files**: quick-install.sh, quick-install-interactive.sh
- **Issue**: TTS test runs in background without checking if it worked
- **Fix**: Add success/failure check

## High Priority Bugs

### 5. uv PATH not persistent
- **File**: quick-install.sh line 108
- **Issue**: PATH update only for current session
- **Fix**: Document need to restart shell or add to shell config

### 6. No backup before overwriting mcp.json
- **File**: quick-install.sh
- **Issue**: mcp.json may be overwritten without backup
- **Fix**: Check if exists and backup first

### 7. Standalone droid file paths may not exist
- **File**: quick-install.sh lines 229-232
- **Issue**: Tries to download standalone .md files that may not exist
- **Fix**: Validate URLs or remove if not needed

## Medium Priority Bugs

### 8. npm init output not suppressed
- **Files**: quick-install.sh, quick-install-interactive.sh
- **Issue**: `npm init -y` creates package.json with verbose output
- **Fix**: Use `npm init -y --silent` or redirect output

### 9. Arbitrary sleep time
- **Files**: quick-install.sh, quick-install-interactive.sh
- **Issue**: `sleep 1` is arbitrary after TTS test
- **Fix**: Wait for background process or remove sleep
