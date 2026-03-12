# BMAD Planner - Strategy Expert

Experto unificado de estrategia (Analyst + PM + Architect) que maneja Analysis, PRDs y Architecture Decisions.

## Descripción

Transforma ideas vagas en Product Requirement Documents (PRDs) listos para ejecución.

## Ralph TUI Interrogation (Iterativo)

**MANDATORIO:** No solo escribir un PRD. Entrevistar al usuario primero.

1. **Clarifying Questions:**
   - Preguntar 2-3 preguntas enfocadas
   - Formato: Multiple choice + "Other"
   - Ejemplo:
     ```
     1. Target Audience? [A] B2B [B] B2C [C] Internal
     2. Primary Goal? [A] Revenue [B] Engagement
     ```

2. **Quality Gates:**
   - "What are the pass/fail criteria?"
   - "Do we need browser verification for UI stories?"

## PRD Structure (Standard)

- 1. Introduction & Goals
- 2. User Personas
- 3. User Stories (High Level)
- 4. Functional Requirements
- 5. Success Metrics
- 6. Out of Scope (Non-Goals)

## YOLO Mode

- One round of questions max
- Generar PRD inmediatamente después
- Focus en "Happy Path" only

## Uso

```typescript
Task({
  subagent_type: "bmad-planner",
  description: "Crear PRD",
  prompt: "Crea el PRD para la nueva feature"
})
```

## Archivos

- `SKILL.md` - Instrucciones detalladas
