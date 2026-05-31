---
name: agent-author
description: >-
  Crea y modifica agentes en agents/ para el arnés Harness: leader,
  implementers backend/frontend, reviewers, docker_manager. Usar al ampliar
  orquestacion, definir roles por capa, o actualizar leader y reglas.
---

# Agent Author — Crear y modificar agentes

## Cuándo usar

- Añadir implementer/reviewer especializado (backend, frontend, E2E, etc.)
- Modificar responsabilidades de un agente existente
- Actualizar leader para enrutar nuevos subagentes

## Workflow

1. Lee [catalog.md](catalog.md) y el agente más cercano en `agents/`.
2. Elige plantilla en [templates/](templates/):
   - `implementer-base.md` — implementadores
   - `reviewer-base.md` — revisores
   - `backend_implementer.md` / `frontend_implementer.md` — diffs por capa
3. Escribe `agents/<name>.md` con frontmatter:

```yaml
---
name: backend_implementer
description: Implementa features backend en product/backend/ segun spec SDD.
tools: Read, Write, Edit, Glob, Grep, Bash
model: inherit
---
```

4. Secciones obligatorias: Pre-condiciones, Protocolo, Reglas duras, Comunicación con leader.
5. Integración (si el leader debe lanzarlo):
   - Actualizar `agents/leader.md` (enrutamiento + escalado)
   - Actualizar reglas del proyecto (`CLAUDE.md` / `rules/leader-role.mdc`)
   - Actualizar `AGENTS.md` del proyecto (mapa §2)
   - Si el rol es nuevo en `models.config.json` → profiles, documentar en skill `model-routing`
6. Validar separación de roles: implementer no revisa; reviewer no edita código.

## Checklist post-creación

- [ ] Frontmatter `name` coincide con nombre del archivo (sin .md)
- [ ] `description` en tercera persona, ≤1024 chars
- [ ] `model: inherit` (leader resuelve desde models.config.json)
- [ ] Límites de alcance explícitos
- [ ] leader.md referencia cuándo lanzar el agente

## Recursos

- Catálogo: [catalog.md](catalog.md)
- Plantillas: [templates/](templates/)
