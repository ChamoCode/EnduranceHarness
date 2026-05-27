# Design — harness_cleanup

## Archivos a eliminar

| Ruta | Motivo |
|------|--------|
| `src/` | Producto embebido notes-cli |
| `tests/` | Tests del producto embebido |
| `specs/cli_recent/` | Spec SDD del CLI |
| `progress/impl_*.md` | Artefactos de implementación CLI |
| `progress/review_*.md` | Artefactos de revisión CLI |
| `progress/explore_*.md` | Artefactos de exploración CLI |

## Archivos a modificar

| Ruta | Cambio |
|------|--------|
| `progress/current.md` | Reset a plantilla |
| `progress/history.md` | Append entrada de migración |
| `.gitignore` | `.env`, quitar `.notes*.json` |

## Alternativa descartada

**Mover a `examples/notes-cli/`:** Rechazada porque el plan exige producto 100% externo sin demo embebida.

## Nota sobre docs

Las referencias rotas a `src/`/`tests/` en docs y agentes se corrigen en la feature `harness_docs` (feature #5), no en esta.
