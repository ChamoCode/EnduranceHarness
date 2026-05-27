#!/usr/bin/env bash
# docker/scripts/build.sh — Construye la imagen harness
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${SCRIPT_DIR}/../docker-compose.yml"
docker compose -f "$COMPOSE_FILE" build harness
echo "[OK] Imagen harness construida"
