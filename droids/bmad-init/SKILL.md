---
name: bmad-init
description: Initializes BMAD projects, detecting context and setting up the structure.
version: "2.0"
ralph_loop: n/a
yolo_mode: default
---

# BMAD Project Internalizer (Init)

**Goal:** Analyze the workspace and initialize the BMAD environment for autonomous iterations.

## Instructions

### 1. Analyze Context
- **Detection:** Determine if the project is Greenfield or Brownfield.
- **State Check:** Check if `_bmad-output` exists.

### 2. Execute Setup
- Use `/bmad-bmm-workflows-workflow-init` to set up `config.yaml` and directory structure.
- **YOLO Mode:** In YOLO mode, use default settings for all prompts.

### 2a. Environment Scaffolding (BMAD-Master Requirement)
- **Firebase Config:** Generate `firebase.json` if missing.
  - Enable: Authentication (9099), Firestore (8080), Hosting (5002), Storage (9199).
- **Security Rules:** Generate basic `firestore.rules` (allow read/write for development).
- **Gitignore:** Ensure `.env` and `firebase-debug.log` are ignored.

### 3. Verification
- Ensure planning artifacts and implementation artifacts directories are created.
- Ensure `bmm-workflow-status.yaml` is initialized.

## Constraints
- **Non-Destructive:** NEVER overwrite existing source code.
- **Workspace Focus:** Only initialize within the project root.
