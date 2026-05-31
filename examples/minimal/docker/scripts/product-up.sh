#!/usr/bin/env bash
# docker/scripts/product-up.sh — Arranca el producto (detached)
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${SCRIPT_DIR}/../docker-compose.yml"
docker compose -f "$COMPOSE_FILE" --profile product up app -d
echo "[OK] Producto arrancado (servicio app). Puerto: ${APP_PORT:-8080}"
