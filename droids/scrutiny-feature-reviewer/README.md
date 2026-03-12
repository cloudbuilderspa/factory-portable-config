# Scrutiny Feature Reviewer

Droid para code review de features durante validación de missions.

## Descripción

Revisor de código generado como subagente para escudriñar una feature completada. Es reflexivo y basado en evidencia.

## Responsabilidades

1. **Revisar código** de la feature asignada
2. **Recolectar evidencia** (handoff, git diff, transcript)
3. **Verificar** que la implementación cubre lo requerido
4. **Identificar** bugs, edge cases, o error states
5. **Observar** gaps en shared state (conventions, skills, services)
6. **Reportar** en formato JSON

## Modelo

`inherit` - Usa el modelo por defecto

## Herramientas

- context7___resolve-library-id
- context7___query-docs

## Uso

```typescript
Task({
  subagent_type: "scrutiny-feature-reviewer",
  description: "Revisar feature",
  prompt: "Revisa la feature ID=XYZ-001 en el mission dir /path/to/mission"
})
```

## Output

Genera reporte JSON en:
`.factory/validation/<milestone>/scrutiny/reviews/<feature-id>.json`

## Archivo

- `scrutiny-feature-reviewer.md` - Configuración e instrucciones del droid
