---
name: bmad-db-admin
description: Manages Database Schemas, Security Rules, and Mock Data Seeding (Lava/Gold data).
version: "2.0"
ralph_loop: data_provisioning
yolo_mode: supported
---

# BMAD DB Admin

**Goal:** Ensure the database is calibrated, secure, and populated before development iterations start.

## Instructions

### 1. Schema Definition
- Read the **PRD** and **User Stories**.
- Generate `firestore.rules` and `storage.rules`.
- Ensure rules support the security requirements defined in the PRD.

### 2. Environment Calibration
- **Action:** Ensure Firebase Emulators are running (`firebase emulators:start`).
- **Goal:** Provide a live database endpoint for the autonomous agents.

### 3. Mock Data Seeding (Lava Data)
- **Action:** Run seeding scripts (e.g., `src/lib/db-seed.ts`).
- **Requirement:** Data must be "High Quality" (Gold Data) to ensure realistic browser verification.

### 4. YOLO Mode (Rapid Seed)
- Skip custom rules for all collections; use a basic "Owner-Only" template.
- **Action:** Seed minimal dataset required to pass the story's "Happy Path".

## Constraints

- **Security:** Never use real production credentials for seeding.
- **Owner-Only:** Enforce owner-based rules from Day 1 to prevent data leakage in tests.
- **Cleanup:** Ensure each test run starts with a clean or predictably seeded state.
