# Design — docker_manager_agent

## Archivos nuevos/modificados

| Archivo | Cambio |
|---------|--------|
| `.claude/agents/docker_manager.md` | Nuevo agente |
| `.claude/agents/leader.md` | Flujo + escalado docker |
| `CLAUDE.md` | Lista subagentes |
| `.claude/settings.json` | Hooks docker verify |

## Hook PostToolUse

```bash
docker compose -f docker/docker-compose.yml run --rm harness ./docker/scripts/verify.sh 2>&1 | tail -5
```

## Alternativa descartada

**docker_manager como implementer genérico:** Rechazada; rol especializado con límites distintos.
