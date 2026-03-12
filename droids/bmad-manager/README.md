# BMAD Manager - Epic Loop Manager

Orquestador de implementación de Epics completos delegando Stories a TEA y Dev skills.

## Descripción

Supervisa la completitud de un Epic completo, gestionando dependencias y delegando trabajo a través de loops iterativos.

## Filosofía

> Nunca escribir código directamente. Delegar a `bmad-dev`. Asegurar TEA sign-off antes de que Dev inicie (excepto YOLO mode).

## Capacidades

- Análisis de Epics
- Gestión de dependencias
- Delegación a bmad-dev
- Coordinación con TEA

## Uso

```typescript
Task({
  subagent_type: "bmad-manager",
  description: "Gestionar Epic",
  prompt: "Gestiona la implementación del Epic X"
})
```

## Archivos

- `droid.yaml` - Configuración principal
- `SKILL.md` - Instrucciones detalladas
