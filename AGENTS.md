# AGENTS.md — Mapa del plugin Endurance Harness Engineering

> Este archivo describe el **repositorio del plugin**, no un proyecto scaffoldado.
> En proyectos creados con `endurance init`, lee el `AGENTS.md` generado en la raiz del proyecto.

## Mapa del plugin

| Ruta | Contenido |
|------|-----------|
| `agents/` | Subagentes SDD (leader, spec_author, implementers, reviewers) |
| `skills/` | feature-list, agent-author, model-routing |
| `rules/` | Reglas Cursor (leader-role, sdd-protocol) |
| `hooks/` | Plantilla hooks.json para proyectos |
| `bin/` | CLI `endurance init` |
| `templates/project/` | Scaffold copiado a cada proyecto nuevo |
| `examples/minimal/` | Proyecto de ejemplo generado por init |

## Skills

| Skill | Uso |
|-------|-----|
| `feature-list` | Backlog con `layer` y `complexity` |
| `model-routing` | Perfiles de modelo por complejidad |
| `agent-author` | Crear o modificar agentes |

## Proyectos scaffoldados

Tras `endurance init`, el proyecto tiene su propio `AGENTS.md`, `feature_list.json`, `models.config.json`, `docker/`, etc.
Los agentes y skills vienen del **plugin instalado**, no se copian al proyecto.
