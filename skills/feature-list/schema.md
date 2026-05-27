# Schema — feature_list.json

## Raíz

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| `project` | string | sí | Identificador del repo de producto |
| `description` | string | sí | Resumen del proyecto |
| `rules` | object | sí | Reglas del arnés (no modificar sin acuerdo) |
| `features` | array | sí | Backlog ordenado por `id` |

## rules (inmutable por defecto)

| Campo | Valor |
|-------|-------|
| `one_feature_at_a_time` | `true` |
| `require_tests_to_close` | `true` |
| `require_approved_spec_to_implement` | `true` |
| `valid_status` | pending, spec_ready, in_progress, done, blocked |
| `sdd_required_when` | feature has "sdd": true |

## Feature

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| `id` | number | sí | Entero único, secuencial |
| `name` | string | sí | snake_case; = `specs/<name>/` |
| `title` | string | sí | Título humano |
| `description` | string | sí | Qué hace la feature |
| `acceptance` | string[] | sí | Criterios verificables |
| `status` | string | sí | Uno de valid_status |
| `sdd` | boolean | recomendado | `true` para producto |
| `layer` | string | opcional | backend, frontend, fullstack, infra, docker |

## Estados y transiciones

```
pending → spec_ready → in_progress → done
              ↓              ↓
           (humano)      blocked
```

- Solo `spec_author` pone `spec_ready`
- Solo leader (con aprobación humana) pone `in_progress`
- Solo implementer + reviewer APPROVED ponen `done`

## Validación automática

`docker/scripts/verify.sh` comprueba:

- JSON parseable
- Estados válidos
- Máximo 1 `in_progress`
- Specs SDD presentes para features en spec_ready/in_progress/done
