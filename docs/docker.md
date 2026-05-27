# Docker — Producto dentro del repo

> El producto vive en `product/` y `tests/` del mismo repositorio.
> Se empaqueta en imagen, se testea, arranca y detiene via Docker Compose.

## Flujo tipico

```bash
./docker/scripts/product-build.sh    # construir imagen
./docker/scripts/product-test.sh     # tests en contenedor
./docker/scripts/product-up.sh       # arrancar app (detached)
./docker/scripts/product-down.sh     # detener
```

## Servicios compose (perfil `product`)

| Servicio | Funcion |
|----------|---------|
| `harness` | Verificacion del arnes (`verify.sh`) — perfil default |
| `app` | Producto en ejecucion; puerto `${APP_PORT:-8080}` |
| `test` | Misma imagen; ejecuta `run-product-tests.sh` y sale |

## Configuracion

1. Copia variables de entorno:

   ```bash
   cp docker/.env.example .env
   ```

2. Edita `.env`:

   ```env
   GITHUB_EXPECTED_USER=tu-login    # opcional
   APP_PORT=8080
   ```

## Adaptar la imagen del producto

`docker/Dockerfile.product` es una plantilla generica (Python 3.11).
Cuando una feature SDD lo requiera, el `docker_manager` adapta:

- Base image (Node, Go, etc.)
- `COPY` de dependencias (`requirements.txt`, `package.json`, ...)
- `CMD` / entrypoint real del producto
- Servicios adicionales en compose (DB, cache, ...)

## Anadir servicios (DB, Redis, ...)

1. `spec_author` documenta requisitos en `design.md`
2. `docker_manager` anade servicios bajo perfil `product` en `docker-compose.yml`
3. `reviewer` verifica smoke test documentado

Ejemplo:

```yaml
services:
  db:
    profiles: [product]
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: dev
```

## Scripts del arnes vs producto

| Script | Que valida |
|--------|------------|
| `verify.sh` | Estructura del arnes, feature_list, specs |
| `run-product-tests.sh` | Tests en `tests/` del producto |
| `product-*.sh` | Build / test / up / down del producto |

## Patron avanzado (opcional)

Montar codigo desde **otro repo** via volumen en compose es posible pero **no**
es el flujo principal. La convencion recomendada es clonar esta plantilla y
desarrollar el producto in-repo con SDD.

## Troubleshooting

| Problema | Solucion |
|----------|----------|
| `Docker daemon no responde` | Inicia Docker Desktop |
| `gh auth status` falla | `gh auth login` |
| Build falla sin codigo en `product/` | Normal en plantilla vacia; implementa primera feature SDD |
| Tests vacios | `run-product-tests.sh` sale 0 con WARN hasta que existan tests |
| Puerto en uso | Cambia `APP_PORT` en `.env` |

## Principio

Todo lo que dependa del stack del producto (run, test, deps) ocurre **dentro**
de contenedores definidos en compose, no asumiendo herramientas en el host.
