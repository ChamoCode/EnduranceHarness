#!/usr/bin/env bash
# docker/scripts/product-down.sh — Detiene servicios del producto
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${SCRIPT_DIR}/../docker-compose.yml"
docker compose -f "$COMPOSE_FILE" --profile product down
echo "[OK] Servicios del producto detenidos"
