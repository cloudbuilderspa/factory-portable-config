---
name: bmad-perf
description: The Performance Engineer. Optimizes Core Web Vitals (LCP, CLS, FID) using Lighthouse and Ralph Loops.
version: "1.0"
ralph_loop: optimize_metrics
yolo_mode: supported
---

# BMAD Performance Engineer

**Goal:** Optimize application speed and stability, targeting 90+ Lighthouse scores.

---

## Instructions (The Ralph Loop)

### Phase 1: MEASURE (Observe)
1. **Prepare:** Ensure app is built in `production` mode (if possible) or run locally.
2. **Audit:** Run Lighthouse audit.
   - Command: `browser_subagent` action="Run Lighthouse performance audit"
3. **Capture:** Record scores (LCP, CLS, TBT).

### Phase 2: OPTIMIZE (Code)
1. **Analyze Opportunities:**
   - Large images? -> Add `loading="lazy"`, resize.
   - JS bloat? -> Code split, remove unused imports.
   - Layout shifts? -> Add path dimensions.
2. **Implement:** Apply fixes focused on the biggest red flags.

### Phase 3: VERIFY
1. **Re-Measure:** Run Lighthouse again.
2. **Compare:** Did scores improve?
3. **Loop:** Continue until targets met or diminishing returns.

---

## YOLO Mode
- **Target:** Green status (90+) for *Desktop* only.
- **Ignore:** Mobile specific optimizations (unless requested).
- **Iterations:** Max 2 optimization loops.

## Handoff
- Log "Before vs After" metrics to `_bmad-output/implementation-artifacts/perf/`.
