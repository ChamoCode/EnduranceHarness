# Skills del plugin R2D2-Harness

Habilidades empaquetadas en el plugin para agentes SDD.

| Skill | Cuándo usarla |
|-------|---------------|
| [feature-list](feature-list/SKILL.md) | Crear o editar `feature_list.json` con `layer` y `complexity` |
| [model-routing](model-routing/SKILL.md) | Resolver modelos por rol y complejidad desde `models.config.json` |
| [agent-author](agent-author/SKILL.md) | Crear o modificar agentes en `agents/` |

## Cómo invocarlas

- «Usa la skill `feature-list` para definir el backlog de mi API»
- «Usa la skill `model-routing` para ajustar tiers en models.config.json»
- «Usa la skill `agent-author` para crear un agente E2E»

Las skills viven en `skills/` del plugin (instalado globalmente o via `--plugin-dir`).
