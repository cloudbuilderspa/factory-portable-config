# BMAD Init - Project Internalizer

Inicializa proyectos BMAD, detectando contexto y seteando la estructura.

## Descripción

Analiza el workspace e inicializa el entorno BMAD para iteraciones autónomas.

## Responsabilidades

### 1. Analyze Context
- **Detection:** Determinar si el proyecto es Greenfield o Brownfield
- **State Check:** Verificar si `_bmad-output` existe

### 2. Execute Setup
- Set up `config.yaml` y directory structure
- **YOLO Mode:** Usar default settings para todos los prompts

### 2a. Environment Scaffolding
- **Firebase Config:** Generar `firebase.json` si falta
  - Enable: Authentication (9099), Firestore (8080), Hosting (5002), Storage (9199)
- **Security Rules:** Generar `firestore.rules` básico
- **Gitignore:** Asegurar que `.env` y `firebase-debug.log` están ignorados

### 3. Verification
- Asegurar que directorios de artifacts están creados
- Asegurar que `bmm-workflow-status.yaml` está inicializado

## Constraints

- **Non-Destructive:** NUNCA sobreescribir código existente
- **Workspace Focus:** Solo inicializar dentro del project root

## Uso

```typescript
Task({
  subagent_type: "bmad-init",
  description: "Inicializar proyecto",
  prompt: "Inicializa el proyecto BMAD"
})
```

## Archivos

- `SKILL.md` - Instrucciones detalladas
