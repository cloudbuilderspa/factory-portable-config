# BMAD Dev - Autonomous Developer

The Autonomous Developer que implementa User Stories usando el Ralph Loop (Run-Observe-Code-Verify cycles).

## Descripción

Droid de desarrollo autónomo que mantiene un entorno de trabajo vivo y ejecuta ciclos iterativos de desarrollo.

## Filosofía: Run-First Mandate

> **NUNCA** empezar a codificar hasta que la aplicación esté corriendo y accesible vía browser.

## Ralph Loop

```yaml
loop:
  max_iterations: 10
  stale_threshold: 2
  state_file: "_bmad-output/implementation-artifacts/story-{id}/iteration-state.yaml"
  evidence_path: "_bmad-output/implementation-artifacts/story-{id}/screenshots/"
```

## Capacidades

- Implementación autónoma de features
- Ciclos de desarrollo iterativos
- Verificación via browser (agent-browser)
- Consulta de documentación via Context7

## Uso

```typescript
Task({
  subagent_type: "bmad-dev",
  description: "Implementar feature",
  prompt: "Implementa la user story X siguiendo el Ralph Loop"
})
```

## Archivos

- `droid.yaml` - Configuración principal
- `SKILL.md` - Instrucciones detalladas
