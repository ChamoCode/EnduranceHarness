---
name: agent-author
description: >-
  Crea y modifica agentes en .claude/agents/ para el arnés Harness: leader,
  implementers backend/frontend, reviewers, docker_manager. Usar al ampliar
  orquestacion, definir roles por capa, o actualizar leader y CLAUDE.md.
---

# Agent Author — Crear y modificar agentes

## Cuándo usar

- Añadir implementer/reviewer especializado (backend, frontend, E2E, etc.)
- Modificar responsabilidades de un agente existente
- Actualizar leader para enrutar nuevos subagentes

## Workflow

1. Lee [catalog.md](catalog.md) y el agente más cercano en `.claude/agents/`.
2. Elige plantilla en [templates/](templates/):
   - `implementer-base.md` — implementadores
   - `reviewer-base.md` — revisores
   - `backend_implementer.md` / `frontend_implementer.md` — diffs por capa
3. Escribe `.claude/agents/<name>.md` con frontmatter:

```yaml
---
name: backend_implementer
description: Implementa features backend en product/backend/ segun spec SDD.
tools: Read, Write, Edit, Glob, Grep, Bash
---
```

4. Secciones obligatorias: Pre-condiciones, Protocolo, Reglas duras, Comunicación con leader.
5. Integración (si el leader debe lanzarlo):
   - Actualizar `.claude/agents/leader.md` (enrutamiento + escalado)
   - Actualizar `CLAUDE.md` (lista subagentes)
   - Actualizar `AGENTS.md` (mapa §2)
6. Validar separación de roles: implementer no revisa; reviewer no edita código.

## Checklist post-creación

- [ ] Frontmatter `name` coincide con nombre del archivo (sin .md)
- [ ] `description` en tercera persona, ≤1024 chars
- [ ] Límites de alcance explícitos (qué carpetas puede tocar)
- [ ] leader.md referencia cuándo lanzar el agente
- [ ] No solapa responsabilidades con agente existente

## Modificar agente existente

1. Lee versión actual completa.
2. Cambio mínimo: no reescribir si solo añades una regla.
3. Si cambias enrutamiento, actualiza leader y catalog.md.
4. Documenta en `progress/current.md` si es sesión activa.

## Recursos

- Catálogo de roles: [catalog.md](catalog.md)
- Plantillas: [templates/](templates/)
