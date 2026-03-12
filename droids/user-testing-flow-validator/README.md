# User Testing Flow Validator

Droid para testear assertions de validation contract a través de la superficie de usuario real durante mission validation.

## Descripción

Subagente generado para testear specific validation contract assertions a través de la superficie de usuario real.

## Asignación

El validador padre asigna:
- IDs de assertions específicas a testear
- Credenciales de test (account, password)
- Data namespace a usar
- Mission dir path
- Output file path para test report

## Responsabilidades

1. **Leer assertions asignadas** de validation-contract.md
2. **Testear cada assertion** a través de la superficie real:
   - Web UI: agent-browser skill
   - CLI/TUI: tuistory skill
   - API: curl
3. **Capturar evidencia** (screenshots, console errors, network calls)
4. **Reportar** resultados (pass/fail/blocked/skipped)

## Modelo

`inherit` - Usa el modelo por defecto

## Herramientas

- Skill: agent-browser
- Skill: tuistory
- context7___resolve-library-id
- context7___query-docs

## Uso

```typescript
Task({
  subagent_type: "user-testing-flow-validator",
  description: "Testear flows",
  prompt: "Testea las assertions VAL-AUTH-001 y VAL-AUTH-002 en el mission dir /path/to/mission"
})
```

## Output

Genera reporte JSON en:
`.factory/validation/<milestone>/user-testing/flows/<group-id>.json`

## Status

- **pass**: assertion behavior confirmed working
- **fail**: assertion behavior does not match spec (bug found)
- **blocked**: cannot test due to broken prerequisite
- **skipped**: solo si explícitamente indicado

## Archivo

- `user-testing-flow-validator.md` - Configuración e instrucciones del droid
