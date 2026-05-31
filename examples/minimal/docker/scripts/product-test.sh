#!/usr/bin/env bash
# docker/scripts/product-test.sh — Ejecuta tests del producto en contenedor
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${SCRIPT_DIR}/../docker-compose.yml"
docker compose -f "$COMPOSE_FILE" --profile product run --rm test
echo "[OK] Tests del producto completados"
