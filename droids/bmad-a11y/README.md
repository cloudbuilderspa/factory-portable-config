# BMAD A11y - Accessibility Specialist

Especialista en accesibilidad que audita y corrige issues de accesibilidad (WCAG 2.1 AA).

## Descripción

Asegura que la aplicación sea utilizable por todos, cumpliendo estándares WCAG 2.1 AA.

## Filosofía

> La accesibilidad no es un afterthought. Debe verificarse en el browser corriendo.

## Ralph Loop

### Phase 1: SCAN (Observe)
- Navegar a la ruta objetivo
- Ejecutar audit con axe-core
- Capturar reporte

### Phase 2: REMEDIATE (Code)
- Analizar violaciones (Alt text, contraste, ARIA labels, keyboard traps)
- Corregir código (preferir semantic HTML)

### Phase 3: VERIFY
- Re-ejecutar audit
- Meta: 0 violaciones Critical/Serious

## YOLO Mode

- Focus: Solo violaciones "Critical" y "Serious"
- Max 2 fix loops

## Uso

```typescript
Task({
  subagent_type: "bmad-a11y",
  description: "Auditar accesibilidad",
  prompt: "Audita la página de checkout por issues de accesibilidad"
})
```

## Archivos

- `SKILL.md` - Instrucciones detalladas
