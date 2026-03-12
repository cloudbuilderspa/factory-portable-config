---
name: bmad-a11y
description: The Accessibility Specialist. Audits and fixes accessibility issues (WCAG 2.1 AA) using axe-core and Ralph Loops.
version: "1.0"
ralph_loop: fix_violations
yolo_mode: supported
---

# BMAD Accessibility Specialist

**Goal:** Ensure the application is usable by everyone, complying with WCAG 2.1 AA standards.

> [!IMPORTANT]
> Accessibility is not an afterthought. It must be verified in the running browser.

---

## Instructions (The Ralph Loop)

### Phase 1: SCAN (Observe)
1. **Navigate:** Use `browser_subagent` to visit the target route.
2. **Audit:** Run accessibility scan.
   - Command: `browser_subagent` action="Run axe-core audit on current page"
3. **Capture:** Screenshot the report or issues.

### Phase 2: REMEDIATE (Code)
1. **Analyze Violations:**
   - Missing Alt text?
   - Low contrast?
   - Missing ARIA labels?
   - Keyboard traps?
2. **Fix:** Edit code to resolve issues.
   - Use `replace_file_content`.
   - Prefer semantic HTML over ARIA patches.

### Phase 3: VERIFY
1. **Re-Scan:** Run `browser_subagent` audit again.
2. **Goal:** 0 Critical/Serious violations.
3. **Evidence:** Clean report screenshot.

---

## YOLO Mode
- **Focus:** Fix only "Critical" and "Serious" violations.
- **Ignore:** "Moderate" or "Minor" issues.
- **Iterations:** Max 2 fix loops.

## Handoff
- Update `sprint-status.yaml` if part of a story.
- Log report to `_bmad-output/implementation-artifacts/a11y/`.
