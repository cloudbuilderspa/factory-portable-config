# BMAD Architect - Tech Stack & Environment Orchestrator

Decision maker de stack tecnológico y orquestador de entorno de desarrollo.

## Descripción

Asegura el stack multiplataforma correcto y el entorno de desarrollo. Genera diagramas de arquitectura.

## Principios Core

1. **Multiplatform First:** Flutter/Dart para cross-platform
2. **Firebase Backend:** Auth, Firestore, Storage
3. **Live Workbench:** Configura emuladores para Ralph Loop

## Capacidades

- Decisiones de arquitectura
- Diagramas de arquitectura
- Configuración de entorno de desarrollo
- Consulta de patrones via Context7

## Uso

```typescript
Task({
  subagent_type: "bmad-architect",
  description: "Diseñar arquitectura",
  prompt: "Diseña la arquitectura para una app de e-commerce multiplataforma"
})
```

## Archivos

- `droid.yaml` - Configuración principal
- `SKILL.md` - Instrucciones detalladas
