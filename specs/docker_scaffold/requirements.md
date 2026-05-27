# Requirements — docker_scaffold

> Feature #2. Infraestructura Docker del arnés para verificación reproducible.

## R1
El sistema DEBE proporcionar `docker/Dockerfile.harness` con bash, git, GitHub CLI, python3 y docker-cli.

## R2
El sistema DEBE proporcionar `docker/docker-compose.yml` con un servicio `harness` que monte el workspace y el socket Docker.

## R3
CUANDO se ejecute `docker/scripts/verify.sh`, el sistema DEBE validar `feature_list.json` (estados válidos, máximo una feature `in_progress`, specs SDD presentes).

## R4
CUANDO se ejecute `docker/scripts/verify.sh`, el sistema DEBE verificar la existencia de los archivos base del arnés.

## R5
El sistema DEBE proporcionar `docker/scripts/build.sh` para construir la imagen harness.

## R6
El sistema DEBE proporcionar `docker/scripts/shell.sh` para entrar al entorno interactivo del contenedor.

## R7
El sistema DEBE proporcionar `docker/.env.example` documentando `PRODUCT_PATH` y `GITHUB_EXPECTED_USER`.

## R8
DONDE exista la carpeta `tests-harness/`, el sistema DEBE ejecutar sus tests durante `verify.sh`.
