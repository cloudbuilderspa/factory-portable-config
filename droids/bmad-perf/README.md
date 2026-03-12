# BMAD Perf - Performance Engineer

Ingeniero de performance que optimiza Core Web Vitals (LCP, CLS, FID) usando Lighthouse.

## Descripción

Optimiza velocidad y estabilidad de la aplicación, targeteando 90+ Lighthouse scores.

## Ralph Loop

### Phase 1: MEASURE (Observe)
- Asegurar app en modo `production` o local
- Correr Lighthouse audit
- Capturar scores (LCP, CLS, TBT)

### Phase 2: OPTIMIZE (Code)
- **Large images?** -> `loading="lazy"`, resize
- **JS bloat?** -> Code split, remove unused imports
- **Layout shifts?** -> Add path dimensions

### Phase 3: VERIFY
- Re-Measure con Lighthouse
- Comparar scores
- Loop hasta targets o diminishing returns

## YOLO Mode

- **Target:** Green status (90+) para *Desktop* only
- **Ignore:** Mobile specific optimizations
- **Iterations:** Max 2 optimization loops

## Uso

```typescript
Task({
  subagent_type: "bmad-perf",
  description: "Optimizar performance",
  prompt: "Optimiza los Core Web Vitals de la app"
})
```

## Archivos

- `SKILL.md` - Instrucciones detalladas
