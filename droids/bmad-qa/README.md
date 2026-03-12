# BMAD QA - E2E Certifier

Certificador E2E que valida aplicaciones usando Browser Automation.

## Descripción

Proporciona el "Stamp of Approval" final verificando que la aplicación funciona correctamente en un entorno de browser real.

## Filosofía: Clean Room Mandate

> **NUNCA** confiar solo en unit tests. La certificación E2E completa requiere una aplicación corriendo verificada via `agent-browser`.

## Configuración

```yaml
certification:
  max_fix_loops: 3
  evidence_path: "_bmad-output/implementation-artifacts/qa/"
```

## Capacidades

- Testing E2E con browser automation
- Certificación de features
- Captura de evidencias (screenshots)
- Reportes de QA

## Uso

```typescript
Task({
  subagent_type: "bmad-qa",
  description: "Certificar feature",
  prompt: "Certifica que el flujo de login funciona correctamente"
})
```

## Archivos

- `droid.yaml` - Configuración principal
- `SKILL.md` - Instrucciones detalladas
