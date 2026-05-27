# Skills del arnés R2D2-Harness

Habilidades reutilizables para agentes que trabajan en esta plantilla Harness
Engineering ([R2D2-Harness](https://github.com/ChamoCode/R2D2-Harness)). Léelas cuando el humano pida crear backlog, agentes o ampliar el
equipo de subagentes.

| Skill | Cuándo usarla |
|-------|---------------|
| [feature-list](feature-list/SKILL.md) | Crear o editar `feature_list.json`, resetear backlog tras clonar la plantilla |
| [agent-author](agent-author/SKILL.md) | Crear o modificar agentes en `.claude/agents/`, ampliar orquestación |

## Cómo invocarlas

En Cursor u otro agente, pide explícitamente seguir la skill:

- «Usa la skill `feature-list` para definir el backlog de mi API»
- «Usa la skill `agent-author` para crear un agente de revisión E2E»

Las skills viven en `skills/` (raíz del repo), paralelas a `docs/` y `specs/`.
