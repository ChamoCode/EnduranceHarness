# R2D2-Harness Plugin — Metadata

## Identificador

- **Nombre:** `r2d2-harness`
- **Versión:** 1.0.0
- **Autor:** ChamoCode

## Descripcion corta

Arnés SDD con agentes cooperativos, skills y enrutamiento de modelos por complejidad de feature.

## Instalacion

### Cursor (local)

```powershell
# Windows — junction/symlink al repo clonado
New-Item -ItemType Junction -Path "$env:USERPROFILE\.cursor\plugins\local\r2d2-harness" -Target "C:\path\to\R2D2-Harness"
```

Reinicia Cursor o **Reload Window**.

### Claude Code

```bash
claude plugin install ./path/to/R2D2-Harness --scope user
# o en desarrollo:
claude --plugin-dir /path/to/R2D2-Harness
```

Validacion:

```bash
claude plugin validate /path/to/R2D2-Harness --strict
```

## Comandos incluidos

| Comando | Descripcion |
|---------|-------------|
| `r2d2 init --name X --path Y` | Scaffold de proyecto desde `templates/project/` |

Binarios en `bin/` del plugin (Claude Code los expone en PATH).

## Contenido empaquetado

- `agents/` — 9 subagentes con `model: inherit`
- `skills/` — feature-list, agent-author, model-routing
- `rules/` — leader-role.mdc, sdd-protocol.mdc
- `hooks/hooks.json.template`
- `templates/project/` — no empaquetado como runtime; usado por `r2d2 init`

## Model routing

Proyectos scaffoldados incluyen `models.config.json`. El leader lee `feature.complexity` y resuelve modelos via skill `model-routing`.

Tiers editables por plan del usuario:

| Tier | Cursor (default) | Claude (default) |
|------|------------------|------------------|
| fast | composer-2.5-fast | haiku |
| standard | claude-4.6-sonnet-medium-thinking | sonnet |
| strong | claude-opus-4-8-thinking-high | opus |

## Publicacion

- Cursor: [cursor.com/marketplace/publish](https://cursor.com/marketplace/publish)
- Claude: marketplace propio + `claude plugin marketplace add owner/repo`

## Changelog

### 1.0.0

- Plugin dual Cursor + Claude Code
- Comando `r2d2 init`
- Enrutamiento de modelos por `complexity` en feature_list.json
- Skills feature-list, agent-author, model-routing
