---
name: feature-list
description: >-
  Crea y edita feature_list.json para el arnés Harness SDD: reglas, estados,
  layer backend/frontend, acceptance verificables. Usar al definir backlog,
  resetear plantilla tras clonar, o añadir features con sdd true.
---

# Feature List — Backlog SDD

## Cuándo usar

- Clonar plantilla y reemplazar features de migración por backlog del producto
- Añadir, editar o reordenar features en `feature_list.json`
- Asignar capa (`layer`) para enrutar implementer/reviewer correcto

## Workflow

1. Lee `feature_list.json`, `docs/specs.md` y [schema.md](schema.md).
2. Conserva el bloque `rules` sin cambios salvo acuerdo explícito del humano.
3. Por cada feature nueva:
   - `id` secuencial entero
   - `name` en snake_case estable (= carpeta `specs/<name>/`)
   - `title` legible para humanos
   - `description` una oración clara
   - `acceptance` array de criterios **verificables** (archivos, comandos, tests)
   - `"sdd": true` para features de producto (salvo bootstrap puntual)
   - `"status": "pending"` al crear
   - `layer` opcional: `backend` | `frontend` | `fullstack` | `infra` | `docker`
4. Tras editar, valida JSON y reglas:
   - Máximo una feature en `in_progress`
   - Estados solo: `pending`, `spec_ready`, `in_progress`, `done`, `blocked`
   - `./init.sh` o `docker compose run harness ./docker/scripts/verify.sh`
5. Plantilla vacía para clon: [template-feature_list.json](template-feature_list.json)
6. Ejemplos: [examples.md](examples.md)

## Plantilla de feature

```json
{
  "id": 1,
  "name": "user_auth_api",
  "title": "API de autenticacion",
  "layer": "backend",
  "description": "Endpoints login y registro con JWT.",
  "acceptance": [
    "Existe product/backend/auth.py con login y register",
    "tests/backend/test_auth.py cubre login exitoso y credenciales invalidas",
    "./docker/scripts/product-test.sh pasa"
  ],
  "sdd": true,
  "status": "pending"
}
```

## Enrutamiento por layer

| layer | Implementer | Reviewer |
|-------|-------------|----------|
| `backend` | `backend_implementer` | `backend_reviewer` |
| `frontend` | `frontend_implementer` | `frontend_reviewer` |
| `fullstack` o ausente | `implementer` | `reviewer` |
| `docker` / `infra` | `docker_manager` (+ implementer si aplica) | `reviewer` |

## Reset tras clonar plantilla

1. Copia [template-feature_list.json](template-feature_list.json) o vacía `features`.
2. Ajusta `project` y `description` al nombre del producto.
3. Añade features del producto con `layer` apropiado.
4. No borres `rules`.

## Anti-patrones

- Acceptance vagos («debe funcionar bien»)
- Varios `in_progress` simultáneos
- `name` con espacios o guiones (usa snake_case)
- Feature SDD sin `"sdd": true`
