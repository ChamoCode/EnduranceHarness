# Schema — feature_list.json

## Raíz

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| `project` | string | sí | Identificador del repo de producto |
| `description` | string | sí | Resumen del proyecto |
| `workflow` | string | no | `lite` en proyectos sin docker; ausente o `full` en proyectos completos |
| `rules` | object | sí | Reglas del arnés (no modificar sin acuerdo) |
| `features` | array | sí | Backlog ordenado por `id` |

## rules (inmutable por defecto)

| Campo | Valor |
|-------|-------|
| `one_feature_at_a_time` | `true` |
| `require_tests_to_close` | `true` |
| `require_approved_spec_to_implement` | `true` |
| `valid_status` | pending, spec_ready, in_progress, done, blocked |
| `valid_complexity` | trivial, simple, medium, complex, very_complex |
| `sdd_required_when` | feature has "sdd": true |
| `tdd_when` | feature has "tdd": true — spec_author genera tests.md, implementer aplica Red-Green-Refactor |

## Feature

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| `id` | number | sí | Entero único, secuencial |
| `name` | string | sí | snake_case; = `specs/<name>/` |
| `title` | string | sí | Título humano |
| `description` | string | sí | Qué hace la feature |
| `acceptance` | string[] | sí | Criterios verificables |
| `status` | string | sí | Uno de valid_status |
| `sdd` | boolean | recomendado | `true` para producto — requiere spec antes de código |
| `tdd` | boolean | no | `true` para aplicar Test-Driven Development (ver abajo) |
| `layer` | string | opcional | backend, frontend, fullstack, infra, docker |
| `complexity` | string | recomendado | trivial, simple, medium, complex, very_complex |
| `model_override` | object | opcional | Override por rol: spec_author, implementer, reviewer, explore |

## Campo `tdd`

Independiente de `sdd`. Se pueden combinar:

| sdd | tdd | Flujo |
|-----|-----|-------|
| false | false | Implementacion libre sin spec ni ciclo TDD |
| true | false | SDD: spec → aprobacion humana → implementacion |
| true | true | SDD + TDD: spec + tests.md → aprobacion humana → Red → Green → Refactor |
| false | true | TDD sin spec formal: implementer escribe tests antes que logica |

Cuando `tdd: true`:
- `spec_author` genera un archivo adicional `specs/<name>/tests.md` con stubs de tests (funcion/endpoint → caso → criterio de fallo esperado).
- El implementer recibe instruccion explicita de escribir tests antes que la logica (Red), hacerlos pasar (Green) y refactorizar (Refactor).
- El reviewer valida que los tests existian antes que la logica (evidencia en `progress/impl_<name>.md`).

## Estados y transiciones

```
pending → spec_ready → in_progress → done
              ↓              ↓
           (humano)      blocked
```

- Solo `spec_author` pone `spec_ready`
- Solo leader (con aprobación humana) pone `in_progress`
- Solo implementer + reviewer APPROVED ponen `done`

## Validación automática (modo full)

`docker/scripts/verify.sh` comprueba:

- JSON parseable
- Estados válidos
- `complexity` válida si presente
- Máximo 1 `in_progress`
- `models.config.json` presente con tiers y profiles
- Specs SDD presentes para features en spec_ready/in_progress/done
