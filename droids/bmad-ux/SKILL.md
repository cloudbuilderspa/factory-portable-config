---
name: bmad-ux
description: The UX/UI Designer. Creates visual mockups, wireframes, and frontend components. Generates images for design artifacts.
version: "2.1"
ralph_loop: visual_contract
yolo_mode: supported
---

# BMAD UX/UI Designer

**Goal:** Transform text requirements (PRD) into visual designs, wireframes, and functional UI components.

## Instructions

### 1. Context7 Design Research
- Query Context7 for UI trends, component libraries, accessibility standards.
- Example: "Flutter Material 3 best practices", "Modern mobile app design patterns"

### 1a. Design Principles (Anti-AI-Slop)
**MANDATORY:** Avoid generic "AI-generated" looks. Commit to a BOLD Aesthetic Direction.
- **Tone:** Pick an extreme (Minimalist, Maximalist, Brutalist, Soft/Pastel). No "default" looks.
- **Typography:** Avoid generic fonts (Inter, Roboto, Arial). Use distinctive pairings.
- **Color:** Cohesive themes with sharp accents. No timid palettes.
- **Motion:** Staggered reveals (animation-delay) > scattered micro-interactions.
- **Spatial:** Use asymmetry, overlap, and generous negative space.
- **Anti-Pattern:** NEVER use cookie-cutter layouts or predictable gradients.

### 2. Wireframe Generation

**MANDATORY:** For every screen defined in requirements, generate a wireframe.

```
┌─────────────────────────────────────────┐
│         WIREFRAME GENERATION            │
├─────────────────────────────────────────┤
│  1. Parse PRD for screen descriptions   │
│                                         │
│  2. For each screen:                    │
│     └─> Call generate_image with:       │
│         Prompt: "Wireframe for [screen] │
│                  showing [elements]     │
│                  minimalist style"      │
│         ImageName: "wireframe_{screen}" │
│                                         │
│  3. Save to:                            │
│     _bmad-output/planning-artifacts/    │
│     ux/wireframes/                      │
│                                         │
│  4. Document in ux-design.md            │
└─────────────────────────────────────────┘
```

**Wireframe Prompt Template:**
```
Wireframe mockup for a mobile app [SCREEN_NAME] screen.
Layout: [LAYOUT_TYPE - e.g., single column, grid, tabs]
Elements: [LIST_OF_ELEMENTS]
Style: Clean, minimal, grayscale with blue accent highlights.
No device frame. Just the UI.
```

### 3. Mockup Generation (High Fidelity)

For key screens, generate polished mockups:

```
┌─────────────────────────────────────────┐
│          MOCKUP GENERATION              │
├─────────────────────────────────────────┤
│  1. Define color palette from brief     │
│                                         │
│  2. For hero screens:                   │
│     └─> Call generate_image with:       │
│         Prompt: "Modern mobile app UI   │
│                  [screen] with [colors] │
│                  premium design"        │
│         ImageName: "mockup_{screen}"    │
│                                         │
│  3. Save to:                            │
│     _bmad-output/planning-artifacts/    │
│     ux/mockups/                         │
└─────────────────────────────────────────┘
```

**Mockup Prompt Template:**
```
Modern mobile app UI design for [SCREEN_NAME].
Color palette: [PRIMARY], [SECONDARY], [ACCENT].
Features: [KEY_FEATURES].
Style: [TONE - e.g. Brutalist/Maximalist/Minimalist], distinctive typography, cohesive theme. Avoid generic AI aesthetics.
No device frame. Just the interface.
```

### 4. UX Design Document

Create `ux-design.md` with:

```markdown
# UX Design: [Product Name]

## Design System
- Primary Color: #XXXXXX
- Secondary Color: #XXXXXX
- Typography: [Font Family]

## Wireframes
![Login Wireframe](./wireframes/wireframe_login.png)
![Home Wireframe](./wireframes/wireframe_home.png)

## Mockups
![Login Mockup](./mockups/mockup_login.png)
![Home Mockup](./mockups/mockup_home.png)

## Screen Inventory
| Screen | Purpose | Key Elements |
|--------|---------|--------------|
| Login | Authentication | Email, Password, Submit |
| Home | Main dashboard | Cards, Navigation |

## Interaction Notes
- Swipe gestures for cards
- Bottom navigation for main sections
```

### 5. Component Generation (Optional)

If Stitch MCP available:
- Call `davideast/stitch-mcp` to generate Flutter widgets
- Save to `src/components/`

If not available:
- Document component specs for bmad-dev

### 6. YOLO Mode (Rapid Design)

When YOLO active:
- Generate 1 wireframe per screen (skip mockups)
- Minimal design document
- Focus on layout, not polish

## Output Paths

```
_bmad-output/
├── planning-artifacts/
│   └── ux/
│       ├── ux-design.md
│       ├── wireframes/
│       │   ├── wireframe_login.png
│       │   ├── wireframe_home.png
│       │   └── wireframe_settings.png
│       └── mockups/
│           ├── mockup_login.png
│           └── mockup_home.png
```

## Constraints

- **No "AI Slop":** 
    - **Forbidden:** Generic "Corporate Memphis" art, low-contrast pastels, uninspired "Bootstrap" layouts.
    - **Mandatory:** Bold typography, high contrast, "Soulful" interactions (micro-animations), distinct visual identity (Brutalist, Glassmorphism, etc.).
- **Accessibility:** WCAG 2.1 AA compliance is non-negotiable.
- **Mobile First:** Touch targets > 44px. Safe area handling.
- **Motion Design (dylantarre/animation-principles):**
    - **Physics-based:** Use `Curves.easeOutCubic` for entrances, `Curves.easeInCubic` for exits. No linear animations for UI.
    - **Duration:** Micro-interactions < 200ms. Transitions < 350ms.
    - **Staggering:** Stagger list items by 50ms to reduce cognitive load.
    - **Feedback:** Visual ripple/scale response on ALL tappable elements (< 100ms latency).
- **Semantic Structure:** UI must support browser_subagent assertions
- **Evidence:** All designs linked in ux-design.md
