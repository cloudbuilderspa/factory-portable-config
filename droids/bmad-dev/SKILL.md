---
name: bmad-dev
description: The Autonomous Developer (Ralph Loop). Implements User Stories using recursive Run-Observe-Code-Verify cycles with browser verification.
version: "2.0"
ralph_loop: true
yolo_mode: supported
---

# BMAD Autonomous Developer (The Ralph Loop)

**Goal:** Autonomously implement a "READY" User Story by maintaining a live workbench environment and executing iterative development cycles.

## The "Run-First" Mandate

> [!IMPORTANT]
> **NEVER** start coding a feature until the application is running and accessible via a browser. The `browser_subagent` is your eyes and ears throughout development.

---

## Ralph Loop Configuration

```yaml
loop:
  max_iterations: 10  # Override with --max-iterations
  stale_threshold: 2  # Warn after N iterations without changes
  state_file: "_bmad-output/implementation-artifacts/story-{id}/iteration-state.yaml"
  evidence_path: "_bmad-output/implementation-artifacts/story-{id}/screenshots/"

completion_promise:
  type: "browser_assertion"  # or "test_pass" or "custom"
  condition: "Defined in story acceptance criteria"

yolo_mode:
  max_iterations: 5
  retries: 1
  checks_per_story: 1  # vs every iteration in normal
```

---

## Instructions (The Ralph Loop)

### Phase 0: Context Loading (GLOBAL MANDATE)

1. **Read Global Context:**
   - `view_file` `_bmad-output/project-context.md` (or equivalent location).
   - **Constraint:** Violating any mandate in `project-context.md` is a critical failure.

2. **Read Story File:**
   - Load the user story from sprint-status.yaml
   - Parse acceptance criteria as completion promises
   - Check for dependencies (blocked stories)

2. **Research (Context7):**
   - Query `mcp_context7` for relevant patterns
   - Example: "Flutter widget testing best practices"

3. **Load Cross-Functional Context:**
   - **UX/UI:** Check `_bmad-output/planning-artifacts/ux/` or `create-ux-design` output. Review design constraints.
   - **TEA:** Check `_bmad-output/planning-artifacts/testarch/` or `test-design` output. Review test scenarios.
   - **Constraint:** Violating UX specs or Test scenarios is a Blocked state.

4. **Load Previous State:**
   - Check for `iteration-state.yaml`
   - If exists, resume from last iteration
   - If not, start fresh (iteration: 0)

---

### Phase 1: RUN (Workbench Activation)

```
┌─────────────────────────────────────────┐
│              RUN PHASE                  │
├─────────────────────────────────────────┤
│  0. PRE-FLIGHT (Zombie Killer):         │
│     └─> lsof -ti:5002,8080,8081,9099 |  │
│         xargs kill -9 || true           │
│                                         │
│  1. Check SDK Path (Flutter Fix):       │
│     └─> which flutter                   │
│     └─> Only use 'flutter' commands     │
│                                         │
│  2. Build the app (Release Mode):       │
│     └─> flutter build web --release     │
│                                         │
│  3. Start Emulators (Port 8500+):       │
│     └─> firebase emulators:start        │
│         --only hosting,auth,firestore   │
│                                         │
│  4. Verify accessibility:               │
│     └─> browser_subagent navigate       │
│         to localhost:5005               │
└─────────────────────────────────────────┘
```

**Actions:**
- **Zombie Kill:** Always clear ports before starting.
- **Environment:** If Flutter SDK errors occur, export PATH explicitly.
- **Build:** Use `flutter build web --release` and serve via `python3 -m http.server 5005` if `flutter run` freezes.
- **Emulators:** Explicitly bind ports in `firebase.json` (Avoid 8080).
- Use `browser_subagent` to verify localhost is reachable.

**Tools:**
- `dart-mcp-server:run_tests` for build verification
- `browser_subagent` for navigation check

---

### Phase 2: OBSERVE (Browser State Capture)

```
┌─────────────────────────────────────────┐
│            OBSERVE PHASE                │
├─────────────────────────────────────────┤
│  1. Navigate to feature area:           │
│     └─> browser_subagent task=          │
│         "Navigate to [route]"           │
│                                         │
│  2. Document current state:             │
│     └─> What exists?                    │
│     └─> What's missing?                 │
│     └─> What's broken?                  │
│                                         │
│  3. Capture screenshot:                 │
│     └─> Save to evidence path           │
│                                         │
│  4. Identify RED state:                 │
│     └─> Exact failure point             │
│     └─> Expected vs actual              │
└─────────────────────────────────────────┘
```

**Actions:**
- Use `browser_subagent` with detailed task description
- Capture screenshot via recording
- Update `iteration-state.yaml` with observations

**Observation Template:**
```yaml
observation:
  route: "/login"
  current_state: "Login form renders but submit button is disabled"
  missing: "Form validation logic"
  red_state: "Button should be enabled when fields are valid"
```

---

### 3a. Engineering Standards (Mandatory)

**Frontend (React/Next.js/Flutter):**
- **No Waterfalls:** Use `Promise.all` for parallel fetching.
- **No Barrel Imports:** Import directly to optimize bundle size.
- **Optimization:** Use `memo`, `lazy`, and `Suspense` for heavy components.

**Backend (Node/Dart):**
- **Layered Architecture:** Controller -> Service -> Repository.
- **Dependency Injection:** Invert control for testability.
- **Error Handling:** Use custom error classes and global handlers.

**Mobile (React Native/Flutter):**
- **Lists:** Use `FlashList` or `ListView.builder`. Avoid `ScrollView` for long lists.
- **Bundle:** Analyze size on every build. Remove unused assets.
- **FPS:** Profile frames. Re-renders must use `memo` / `const` widgets.

**Flutter/Firebase Specifics (Epic-008):**
- **WIdgets:** Use `StatelessWidget` by default. Use `const` constructors everywhere.
- **Data:** Use `StreamBuilder` for real-time data. Index compound queries.
- **Logic:** Move complex logic to Isolates.

**Flutter Expert Standards (jeffallan/claude-skills):**
- **State Management:** Strict strict separation of Logic (BLoC/Cubit/Riverpod) and UI. No `setState` in complex widgets.
- **Performance:** Const constructors everywhere. `const` widgets don't rebuild.
- **Build Context:** Do NOT access `context` across async gaps. Use `mounted` checks.
- **Assets:** Use generated asset classes (e.g. `Assets.gen.dart`) instead of raw strings.
- **Responsiveness:** Use `LayoutBuilder` or `MediaQuery` safely. Handle overflow with `Expanded`/`Flexible`.

**Build Resilience (Epic-009):**
- **Pre-Flight:** Run `flutter clean` and `flutter analyze` before critical builds.
- **Stale Tests:** Delete `test/` folder if it blocks the build (unless tests are critical).
- **Web:** Check `web/index.html` existence before building.
- **Vertical Slice (Epic-010):** NO MOCK DATA. Implement Backend (Repo/Service) before Frontend (Widgets).
- **Crash Prevention (Epic-011):** 
    - **No "Grey Screen":** Verify `WidgetsFlutterBinding.ensureInitialized()` is first line of `main()`.
    - **Real Architecture:** NEVER replace `main.dart` with "Mocks". Use `FirebaseTelemetryRepository`.
    - **Always Emulator:** BEFORE `browser_subagent`, verify `firebase emulators:start` is running.
- **Seeding Mandate (Epic-011):** 
    - **NO UI-Only Mocks:** Do not create `MockRepository` classes in production code.
    - **Seed Scripts:** Create `tool/seed_data.dart` to populate the running emulator.
    - **Workflow:** `emulators:start` -> `dart run tool/seed_data.dart` -> `flutter build web` -> `verify`.

### Phase 3: CODE (Implementation)

```
┌─────────────────────────────────────────┐
│              CODE PHASE                 │
├─────────────────────────────────────────┤
│  1. Plan changes:                       │
│     └─> Based on observation            │
│     └─> Minimal, focused edits          │
│                                         │
│  2. Write code:                         │
│     └─> write_to_file (new files)       │
│     └─> replace_file_content (edits)    │
│                                         │
│  3. Hot reload:                         │
│     └─> dart-mcp-server:hot_reload      │
│                                         │
│  4. Log changes:                        │
│     └─> Update iteration-state.yaml     │
└─────────────────────────────────────────┘
```

**Constraints:**
- Small, incremental changes preferred
- Follow project patterns (query context7 if unsure)
- Use `mcp_dart-mcp-server_hot_reload` after changes

**Change Log Template:**
```yaml
changes:
  - file: "lib/widgets/login_form.dart"
    action: "Modified"
    description: "Added form validation logic"
  - file: "lib/widgets/submit_button.dart"
    action: "Created"
    description: "New widget for submit button"
```

---

### Phase 4: VERIFY (Browser Validation)

```
┌─────────────────────────────────────────┐
│            VERIFY PHASE                 │
├─────────────────────────────────────────┤
│  1. Test the change:                    │
│     └─> browser_subagent task=          │
│         "Verify [acceptance criteria]"  │
│                                         │
│  2. Capture evidence:                   │
│     └─> Screenshot on success           │
│     └─> Video on failure                │
│                                         │
│  3. Evaluate completion promise:        │
│     └─> If MET: Exit loop (GREEN)       │
│     └─> If NOT MET: Continue loop       │
│                                         │
│  4. Check iteration limits:             │
│     └─> If max reached: Escalate        │
│     └─> If stale: Warn user             │
└─────────────────────────────────────────┘
```

**Locator Priority:**
1. `text=` (visible text)
2. `role=` with name
3. `data-testid=`
4. CSS selector (last resort)

**Retry Logic:**
```yaml
retry:
  max_attempts: 3  # (1 in YOLO mode)
  backoff_ms: [1000, 2000, 4000]
  retry_on: ["timeout", "element_not_found"]
  no_retry_on: ["assertion_failed"]
```

---

### Loop Control

```
┌─────────────────────────────────────────┐
│           LOOP ITERATION                │
├─────────────────────────────────────────┤
│  After VERIFY phase:                    │
│                                         │
│  IF completion_promise MET:             │
│     └─> Status: DONE                    │
│     └─> Update sprint-status.yaml       │
│     └─> Exit loop                       │
│                                         │
│  IF completion_promise NOT MET:         │
│     └─> Increment iteration             │
│     └─> Update iteration-state.yaml     │
│     └─> GOTO Phase 1 (RUN)              │
│                                         │
│  IF max_iterations reached:             │
│     └─> Status: MAX_ITERATIONS          │
│     └─> Notify user                     │
│                                         │
│  IF stale (no changes 2x):              │
│     └─> Warn: "No progress detected"    │
│     └─> Ask user for guidance           │
└─────────────────────────────────────────┘
```

---

## State File Schema

```yaml
# iteration-state.yaml
story_id: "US-001-1"
iteration: 3
phase: "VERIFY"
status: "in-progress"  # or "done", "failed", "max_iterations"

completion_promise:
  type: "browser_assertion"
  condition: "Submit button is enabled when form is valid"
  met: false

last_observation:
  route: "/login"
  state: "Button still disabled"
  screenshot: "screenshots/iter-3-observe.png"

last_changes:
  - file: "lib/widgets/login_form.dart"
    description: "Fixed validation logic"

history:
  - iteration: 1
    result: "FAIL"
    reason: "Button not found"
  - iteration: 2
    result: "FAIL"
    reason: "Button disabled"
  - iteration: 3
    result: "PENDING"
```

---

## YOLO Mode Behavior

When YOLO mode is active:

| Aspect | Normal | YOLO |
|--------|--------|------|
| Max iterations | 10 | 5 |
| Browser checks | Every iteration | 1 per story |
| Retries | 3 | 1 |
| Confirmations | Ask user | Skip all |
| Evidence | Screenshots + Video | Screenshots only |

**Activation:**
- Flag: `--yolo`
- Prompt: Contains "YOLO" keyword
- Config: `yolo_mode: true` in story

---

## Constraints

- **Zero Isolation:** Do not code features in isolation from the full platform suite
- **Eyes on Browser:** Any UI change must be verified by `browser_subagent` before concluding
- **No Build, No Code:** Build must succeed before entering CODE phase
- **Evidence Required:** Every iteration must have screenshot evidence
- **State Persistence:** Always update `iteration-state.yaml` after each phase

---

## Handoff Protocol

When story is DONE:

1. Update `sprint-status.yaml`: story status = "done"
2. Log final evidence path
3. Return status to orchestrator (bmad-manager or bmad-master)
4. If QA needed, pass to bmad-qa for certification
