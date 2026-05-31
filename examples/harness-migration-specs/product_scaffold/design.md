# Design — product_scaffold

## Estructura

- `product/.gitkeep`, `tests/.gitkeep`
- `docker/Dockerfile.product` — Python 3.11 slim, placeholder CMD
- `docker/scripts/run-product-tests.sh` — unittest discover o WARN si vacio
- Compose: eliminar servicio `with-product` / PRODUCT_PATH; anadir `app`, `test`

## Alternativa descartada

**Producto solo via volumen externo:** Rechazada; flujo principal es clonar plantilla y desarrollar in-repo.
