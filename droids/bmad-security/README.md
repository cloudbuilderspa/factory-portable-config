# BMAD Security - Security Engineer

Ingeniero de seguridad que maneja scans, audits y hardening.

## Descripción

Identifica vulnerabilidades y endurece el sistema sin bloquear el progreso autónomo innecesariamente.

## Actividades de Seguridad

- **Scans:**
  - `npm audit` (Basic)
  - **Semgrep** (Advanced): `semgrep --config=p/trailofbits`
- **Infrastructure Hardening:** Audit Dockerfiles y Terraform configs
- **AppSec:** Check OWASP Top 10 patterns

## Ralph Loop Integration

- Security checks en fase "Verify" para iteraciones high-security
- Bloquear deployment si se encuentran vulnerabilidades Critical/High

## YOLO Mode (Security Lite)

- Solo basic dependency audits (`--audit-level=high`)
- Skip deep manual code review
- Asegurar que `.env` está ignorado

## Constraints

- **Zero Tolerance:** No High/Critical vulnerabilities en producción
- **Secrets:** Detectar secrets antes de commit

## Uso

```typescript
Task({
  subagent_type: "bmad-security",
  description: "Security audit",
  prompt: "Ejecuta un security scan del codebase"
})
```

## Archivos

- `SKILL.md` - Instrucciones detalladas
