---
name: feature-list
description: >-
  Crea y edita feature_list.json para el arnés Harness SDD/TDD: reglas, estados,
  layer backend/frontend, complexity, tdd y recomendacion de modelo. Usar al definir
  backlog, tras r2d2 init (lite o full), o al añadir features con sdd/tdd.
---

# Feature List — Backlog SDD/TDD

## Cuándo usar

- Tras `r2d2 init` para reemplazar features de ejemplo por el backlog real
- Añadir, editar o reordenar features en `feature_list.json`
- Asignar `layer`, `complexity` y decidir si la feature usa `tdd`

## Workflow

1. Lee `feature_list.json`, [schema.md](schema.md) y skill `model-routing`.
2. Conserva el bloque `rules` sin cambios salvo acuerdo explícito del humano.
3. Por cada feature nueva, completa todos los campos y **propón** `complexity` y `tdd`.
4. Tras editar, valida JSON y reglas:
   - Máximo una feature en `in_progress`
   - Estados y complexity en enums de `rules`
5. Plantilla vacía: [template-feature_list.json](template-feature_list.json)

## Recomendacion de complexity

| complexity | Senales |
|------------|---------|
| `trivial` | 1 archivo, sin logica nueva |
| `simple` | 1-2 archivos, una capa, CRUD |
| `medium` | Multi-archivo, una capa |
| `complex` | Cross-layer, refactor, Docker |
| `very_complex` | Migracion, arquitectura nueva |

Tras proponer `complexity`, muestra el perfil de modelos resultante desde `models.config.json` → `profiles[complexity]`.

## Cuando usar TDD (`tdd: true`)

Propón `tdd: true` cuando la feature cumple alguna de estas condiciones:

| Señal | Ejemplo |
|-------|---------|
| Logica pura con contratos claros | Parsers, calculadoras, transformaciones |
| API con contratos predefinidos | Endpoints con schema conocido |
| Regresion evitada | Correccion de bug con test que lo reproduzca |
| Complejidad alta + sin tests existentes | `complex` o `very_complex` sin cobertura |

No proponer TDD para: UI con mucho estado visual, integraciones con terceros sin mock, tasks puramente de infra Docker.

**TDD + SDD (combinacion recomendada):**
- `sdd: true` garantiza spec antes de codigo
- `tdd: true` garantiza tests antes que logica
- El spec_author genera `tests.md` con los stubs; el implementer los implementa en Red→Green→Refactor

## Plantilla de feature

```json
{
  "id": 1,
  "name": "user_auth_api",
  "title": "API de autenticacion",
  "layer": "backend",
  "complexity": "medium",
  "tdd": true,
  "description": "Endpoints login y registro con JWT.",
  "acceptance": [
    "POST /login retorna 200 con token valido para credenciales correctas",
    "POST /login retorna 401 para credenciales incorrectas",
    "Tests pasan en CI"
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
| `docker` / `infra` | `docker_manager` | `reviewer` |

## Anti-patrones

- Acceptance vagos
- Varios `in_progress` simultáneos
- Feature SDD sin `"sdd": true`
- `tdd: true` en features de infra Docker o UI puramente visual
- Omitir `complexity` sin justificacion (default leader: `medium`)
