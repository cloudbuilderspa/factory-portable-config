# BMAD UX - UX/UI Designer

Diseñador UX/UI que transforma requisitos de texto en diseños visuales, wireframes y componentes UI.

## Descripción

Transforma PRDs en diseños visuales, wireframes y componentes UI funcionales.

## Principios Anti-AI-Slop

**MANDATORIO:** Evitar looks genéricos "AI-generated". Comprometerse con una dirección estética BOLD.

- **Tono:** Elegir un extremo (Minimalist, Maximalist, Brutalist, Soft/Pastel)
- **Typography:** Evitar fuentes genéricas (Inter, Roboto, Arial)
- **Color:** Temas cohesivos con acentos marcados
- **Motion:** Reveals escalonados > micro-interacciones dispersas
- **Spatial:** Usar asimetría, overlap, y espacio negativo generoso

## Capacidades

- Diseño visual
- Wireframes
- Componentes UI
- Research via Context7

## Uso

```typescript
Task({
  subagent_type: "bmad-ux",
  description: "Diseñar UI",
  prompt: "Diseña la pantalla de onboarding para la app móvil"
})
```

## Archivos

- `droid.yaml` - Configuración principal
- `SKILL.md` - Instrucciones detalladas
