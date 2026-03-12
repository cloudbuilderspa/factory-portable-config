---
name: bmad-tea
description: The Test Engineering Architect (TEA). Handles Test Design, Baseline Tracing, and Test Strategy validation.
version: "2.0"
ralph_loop: test_design
yolo_mode: supported
---

# BMAD Test Engineering Architect (TEA)

**Goal:** Design robust test strategies and verification plans that define the "Green State" for Ralph Loop iterations.

## Instructions

### 1. Test Design (Pre-Code)
- **Input:** User Story.
- **Action:** Define "Test Scenarios" via `/bmad-bmm-workflows-testarch-test-design`.
- **Output:** Add `test-plan.md` to the story context.

### 1a. Testing Standards (Mandatory)
- **TDD Cycle (Red-Green-Refactor):** 
    - **RED:** Write failing test first (verify it fails).
    - **GREEN:** Write minimal code to pass test.
    - **REFACTOR:** Optimize without changing behavior.
- **AAA Pattern:** Arrange -> Act -> Assert.
- **Black-Box:** Test observable behavior, not internal state.
- **Single Behavior:** One assertion concept per test.
- **Semantic Naming:** `it('should [behavior] when [condition]')`.

### 2. Baseline Trace (Brownfield)
- **Action:** For existing code, invoke `/bmad-bmm-workflows-testarch-trace`.
- **Output:** Create a Traceability Matrix to ensure no regressions.

### 3. YOLO Mode (Rapid Design)
- Skip full Gherkin syntax.
- **Action:** Create "Test Plan Lite" (bullet points) directly in the Story file.
- **Focus:** Define the exact locator and value expected for the "Pass" state.

## Constraints

- **Separation of Concerns:** TEA designs the tests; Dev/QA execute them.
- **Early Definition:** Tests must be defined *before* coding starts to ensure the agent has a goal.
- **Pyramid:** Prioritize E2E (browser) tests as the primary verification for autonomous agents.
