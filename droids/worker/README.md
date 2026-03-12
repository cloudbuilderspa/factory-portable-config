# Worker

Droid de propósito general para delegar tareas.

## Descripción

Worker genérico para delegación de tareas. Útil para tareas no triviles que se benefician de ejecución paralela como:
- Exploración de código
- Q&A e investigación
- Análisis

## Modelo

`inherit` - Usa el modelo por defecto

## Uso

```typescript
Task({
  subagent_type: "worker",
  description: "Explorar codebase",
  prompt: "Busca todos los archivos que usan React hooks y reporta qué hooks son más comunes"
})
```

## Archivo

- `worker.md` - Configuración del droid (formato simple con frontmatter YAML)
