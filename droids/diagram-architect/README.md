# Diagram Architect

Droid para crear diagramas de arquitectura cloud, software y sistemas usando código Python.

## Descripción

Genera diagramas de arquitectura profesionales usando la librería Python `diagrams` con consultas a Context7 para documentación actualizada.

## Instalación

```bash
pip install diagrams graphviz
```

## Capacidades

- Diagramas AWS, GCP, Azure, OCI
- Diagramas On-Premises (servidores, bases de datos, redes)
- Diagramas Kubernetes
- Clusters y agrupación de componentes
- Conexiones direccionales y flujos de datos

## Uso

```typescript
Task({
  subagent_type: "diagram-architect",
  description: "Crear diagrama AWS",
  prompt: "Genera un diagrama de arquitectura serverless en AWS con API Gateway, Lambda y DynamoDB"
})
```

## Archivos

- `droid.yaml` - Configuración del droid
- `SKILL.md` - Instrucciones detalladas y ejemplos de código
