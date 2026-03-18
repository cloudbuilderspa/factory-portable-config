# User Testing

## Validation Surface

### Primary Surface: Terminal (CLI)
- **Tools**: bash scripts, manual commands
- **Setup**: None required - all tests run in terminal

### Secondary Surface: File System
- **Tools**: Read, LS
- **Setup**: None required

## Testing Strategy

### Automated Tests
- **Framework**: bats (existing tests in tests/ directory)
- **Coverage**: quick-install-interactive.sh, sync-to-repo.sh, mcp-keyword-detector

### Manual Tests
1. **Full Installation Test**
   - Run `./quick-install.sh` on fresh machine
   - Verify all files installed
   - Test TTS

2. **Interactive Installation Test**
   - Run `./quick-install-interactive.sh`
   - Test each component selection

3. **Dry Run Test**
   - Run with `--dry-run` flag
   - Verify no files modified

## Resource Cost Classification

- **Max Concurrent Validators**: 3
- **Memory per validator**: ~50MB (lightweight - just shell scripts)
- **CPU**: Minimal

## Known Limitations
- Tests require Node.js and ffmpeg to be pre-installed
- TTS tests require audio output (may fail in headless environments)
