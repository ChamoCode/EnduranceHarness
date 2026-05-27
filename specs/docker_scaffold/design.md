# Design — docker_scaffold

## Estructura

```
docker/
├── Dockerfile.harness
├── docker-compose.yml
├── .env.example
└── scripts/
    ├── build.sh
    ├── verify.sh
    └── shell.sh
```

## Dockerfile.harness

- Base: `debian:bookworm-slim`
- Paquetes: git, curl, ca-certificates, python3, docker.io (CLI)
- GitHub CLI: instalación vía script oficial de GitHub
- WORKDIR: `/workspace`

## docker-compose.yml

- Servicio `harness`: build local, volumen `.:/workspace`, socket `/var/run/docker.sock`
- Perfil `with-product`: servicio `product` con volumen `${PRODUCT_PATH}:/product` (placeholder)

## verify.sh

Migrar lógica Python de `init.sh` bloque 3 + lista archivos base + unittest opcional en `tests-harness/`.

## Alternativa descartada

**Imagen Alpine:** Rechazada por fricción instalando `gh` y docker-cli en musl.
