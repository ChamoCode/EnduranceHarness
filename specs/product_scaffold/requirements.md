# Requirements — product_scaffold

> Feature #6. Convencion producto in-repo y ciclo Docker build/test/up/down.

## R1
El sistema DEBE proporcionar directorios `product/` y `tests/` en la raiz del repo.

## R2
El sistema DEBE proporcionar `docker/Dockerfile.product` como plantilla de imagen del producto.

## R3
El sistema DEBE proporcionar servicios `app` y `test` en compose con perfil `product`.

## R4
El sistema DEBE proporcionar scripts `product-build.sh`, `product-test.sh`, `product-up.sh` y `product-down.sh`.

## R5
El README.md DEBE documentar el flujo: clonar plantilla, init, feature_list propio, SDD, producto en product/, ciclo Docker.

## R6
docs/docker.md y docs/architecture.md DEBEN describir producto in-repo, no montaje externo como flujo principal.
