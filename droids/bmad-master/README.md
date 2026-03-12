# BMAD Master - Grand Orchestrator

Orquestador principal que coordina el ciclo de vida completo de BMAD.

## Descripción

Ejecuta el SDLC desde Alignment hasta Certification, asegurando que cada fase de coding empiece con un entorno corriendo.

## La Regla "No Build, No Code"

> Si un build falla, la Ejecución está BLOQUEADA. El agente debe volver a Architecture/Fix mode antes de continuar.

## BMAD Lifecycle Phases

```
Phase 0-1: ALIGNMENT -> Project Init
Phase 2: ANALYSIS -> Product Brief, Research
Phase 3: PLANNING -> PRD Creation, UX Design
Phase 4: SOLUTIONING -> Architecture, Epics & Stories
Phase 5: OPERATIONS & SECURITY -> Environment Lock
Phase 6: EXECUTION -> Live Development (bmad-dev)
Phase 7: CERTIFICATION -> Zero-G Verification (bmad-qa)
Phase 8: OPTIMIZATION -> Performance tuning
Phase 9: RETROSPECTIVE -> Lessons learned
```

## YOLO Mode Orchestration

| Phase | Normal | YOLO |
|-------|--------|------|
| Planning | Full workflows | Quick Spec |
| Execution | All stories | Critical path only |
| Certification | Full E2E | Happy path only |
| Retries | 3 per check | 1 per check |

## Global Rules

1. **No Build, No Code:** Build failure blocks execution
2. **Live Workbench:** App debe estar corriendo para dev work
3. **Evidence Required:** Cada fase tiene artifacts
4. **State Persistence:** Todo progreso en yaml files
5. **Skill Handoffs:** Contratos claros entre skills

## Uso

```typescript
Task({
  subagent_type: "bmad-master",
  description: "Orquestar proyecto",
  prompt: "Coordina el ciclo de desarrollo completo"
})
```

## Archivos

- `SKILL.md` - Instrucciones detalladas
