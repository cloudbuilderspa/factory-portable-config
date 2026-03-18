---
name: validation-worker
description: Runs validation tests for the portable config
---

# Validation Worker

NOTE: Startup and cleanup are handled by `mission-worker-base`. This skill defines the WORK PROCEDURE.

## When to Use This Skill

Use this skill for features that validate:
- Full installation flow
- Cross-component integration
- End-to-end scenarios

## Work Procedure

1. **Preparation**: Ensure all bugfix features are complete.

2. **Run Automated Tests**:
   ```bash
   # Run bats tests if available
   bats tests/*.bats
   ```

3. **Run Dry-Run Tests**:
   ```bash
   ./quick-install.sh --dry-run
   ./quick-install-interactive.sh --dry-run --selections "1,2,3"
   ```

4. **Test Individual Components**:
   - TTS: `~/.factory/hooks/droid-speak.sh "test"`
   - MCP hook: `echo '{"prompt": "aws lambda pricing"}' | python3 hooks/mcp-keyword-detector.py`

5. **Validate Assertions**: Check each assertion in validation-contract.md is satisfied.

6. **Document Results**: Update validation-state.json with pass/fail for each assertion tested.

## Example Handoff
```json
{
  "salientSummary": "Validated full installation flow, all 25 assertions pass.",
  "whatWasImplemented": "Ran bats tests, dry-run tests, component tests, and validated all assertions in validation-contract.md.",
  "whatWasLeftUndone": "",
  "verification": {
    "commandsRun": [
      {"command": "bats tests/*.bats", "exitCode": 0, "observation": "All 2 tests passed"},
      {"command": "./quick-install.sh --dry-run", "exitCode": 0, "observation": "Dry run completed"}
    ],
    "interactiveChecks": [
      {"action": "Tested TTS with 'Hola'", "observed": "Audio played successfully"},
      {"action": "Tested MCP hook with 'aws lambda'", "observed": "Correct instructions injected"}
    ]
  },
  "tests": {"added": [], "run": []},
  "discoveredIssues": []
}
```

## When to Return to Orchestrator

- A critical assertion cannot be satisfied
- Required tool is not available (e.g., bats not installed)
