# Convenciones — Arnés y producto dockerizado

> Homogeneidad en scripts, Docker, carpetas del producto y documentacion.

## Carpetas del producto

```
product/
├── backend/     # API, servicios, dominio server-side
└── frontend/    # UI, client, assets
tests/
├── backend/     # Tests backend (unittest, pytest, etc.)
└── frontend/    # Tests frontend (component, e2e, etc.)
```

| Ruta | Agente |
|------|--------|
| `product/backend/`, `tests/backend/` | `backend_implementer` / `backend_reviewer` |
| `product/frontend/`, `tests/frontend/` | `frontend_implementer` / `frontend_reviewer` |
| Resto de `product/`, `tests/` | `implementer` / `reviewer` (fullstack) |

Campo `layer` en `feature_list.json` enruta al agente correcto. Ver `skills/feature-list/SKILL.md`.

## Scripts shell

- Shebang: `#!/usr/bin/env bash`
- Modo estricto: `set -euo pipefail` (salvo verify con control explicito)
- Salida: prefijos `[OK]`, `[WARN]`, `[FAIL]`
- Scripts de producto: prefijo `product-` en `docker/scripts/`

## Docker

| Elemento | Convencion |
|----------|------------|
| Imagen arnes | `Dockerfile.harness` |
| Imagen producto | `Dockerfile.product` |
| Servicio arnes | `harness` |
| Servicio app | `app` (perfil `product`) |
| Servicio test | `test` (perfil `product`) |
| Compose | `docker/docker-compose.yml` |
| Variables | `.env` en raiz (plantilla `docker/.env.example`) |

## Nombres de archivos

| Tipo | Patron | Ejemplo |
|------|--------|---------|
| Spec | `specs/<feature_name>/` | `specs/user_auth/` |
| Informe implementacion | `progress/impl_<name>.md` | `progress/impl_user_auth.md` |
| Informe Docker | `progress/docker_<name>.md` | `progress/docker_user_auth.md` |
| Informe revision | `progress/review_<name>.md` | `progress/review_user_auth.md` |

## Markdown

- Requirements en EARS estricto (`docs/specs.md`)
- Tasks con `- [ ]` / `- [x]` y referencia `R<n>`

## Git

- No commitear `.env`
- Al clonar la plantilla, reemplazar `feature_list.json` con backlog del producto

## Comentarios en scripts

Solo cuando el *por que* no es obvio.
