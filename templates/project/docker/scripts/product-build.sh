#!/usr/bin/env bash
# docker/scripts/product-build.sh — Construye la imagen del producto
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${SCRIPT_DIR}/../docker-compose.yml"
docker compose -f "$COMPOSE_FILE" --profile product build app test
echo "[OK] Imagen del producto construida (app + test)"
