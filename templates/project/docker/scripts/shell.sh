#!/usr/bin/env bash
# docker/scripts/shell.sh — Entorno interactivo reproducible
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${SCRIPT_DIR}/../docker-compose.yml"
exec docker compose -f "$COMPOSE_FILE" run --rm harness bash
