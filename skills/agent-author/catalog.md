# Catálogo de agentes

| Agente | Rol | Alcance código | Lanza leader cuando |
|--------|-----|----------------|---------------------|
| `leader` | Orquesta, no implementa | docs, progress, feature status (no done) | Siempre (rol principal) |
| `spec_author` | Specs EARS | solo `specs/` | feature `pending` + sdd |
| `backend_implementer` | Implementa API/lógica | `product/backend/`, `tests/backend/` | layer `backend`, in_progress |
| `frontend_implementer` | Implementa UI | `product/frontend/`, `tests/frontend/` | layer `frontend`, in_progress |
| `implementer` | Fullstack/genérico | `product/`, `tests/` | layer ausente o `fullstack` |
| `docker_manager` | Docker/compose | `docker/` | layer `docker`/`infra` o tasks Docker |
| `backend_reviewer` | Aprueba backend | solo lectura backend | tras backend_implementer |
| `frontend_reviewer` | Aprueba frontend | solo lectura frontend | tras frontend_implementer |
| `reviewer` | Aprueba fullstack/infra | lectura todo el diff | tras implementer genérico |

## Orden típico por feature

```
spec_author → (humano) → implementer_* → docker_manager? → reviewer_*
```

## Añadir agente nuevo

1. Define alcance único (sin solapar carpetas).
2. Copia plantilla de [templates/](templates/).
3. Registra aquí y en leader.md.
4. Si reemplaza uno genérico, documenta cuándo usar cada uno.

## Agentes que no editan código

- `leader`, `spec_author`, `reviewer`, `backend_reviewer`, `frontend_reviewer`

## Agentes que marcan tasks [x]

- Todos los implementers y `docker_manager` (solo tasks asignadas)

## Ningún agente marca feature `done` solo

Solo implementer (tras reviewer APPROVED) o leader en cierre de sesión documentado.
