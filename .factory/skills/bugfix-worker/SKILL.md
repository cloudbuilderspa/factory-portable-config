---
name: bugfix-worker
description: Fixes bugs in shell scripts and Python files
---

# Bugfix Worker

NOTE: Startup and cleanup are handled by `mission-worker-base`. This skill defines the WORK PROCEDURE.

## When to Use This Skill

Use this skill for features that fix bugs in:
- Bash scripts (.sh files)
- Python scripts (.py files)
- Node.js scripts (.js files)
- Configuration files (JSON, YAML)

## Work Procedure

1. **Understand the Bug**: Read the feature description carefully to understand what needs to be fixed.

2. **Locate the Code**: Use Grep/Read to find the exact location of the bug in the file.

3. **Fix the Bug**: Make minimal changes to fix the issue:
   - For silent failures: Add error checking and exit codes
   - For missing validation: Add input validation
   - For hardcoded paths: Use variables or portable paths
   - For edge cases: Add conditional handling

4. **Test the Fix**:
   - For bash: Run `bash -n script.sh` for syntax check
   - For Python: Run `python3 -m py_compile script.py`
   - For scripts: Run the relevant test or manual check

5. **Verify**: Confirm the fix addresses the specific assertion in the validation contract.

## Example Handoff

```json
{
  "salientSummary": "Fixed silent failure in npm install by adding error checking and exit code.",
  "whatWasImplemented": "Modified quick-install.sh lines 142-143 to check npm install exit code and exit with error message if failed.",
  "whatWasLeftUndone": "",
  "verification": {
    "commandsRun": [
      {"command": "bash -n quick-install.sh", "exitCode": 0, "observation": "Syntax check passed"},
      {"command": "./quick-install.sh --dry-run", "exitCode": 0, "observation": "Dry run works"}
    ],
    "interactiveChecks": []
  },
  "tests": {"added": [], "run": []},
  "discoveredIssues": [],
  "fulfills": ["VAL-INSTALL-003"]
}
```

## When to Return to Orchestrator

- Feature depends on a file that doesn't exist
- Bug cannot be reproduced
- Fix would require major refactoring (create new feature instead)
