#!/usr/bin/env bash
# init.sh — Verificación e inicialización del entorno (host + contenedor)
#
# Ejecutar al COMENZAR una sesión y antes de declarar cualquier tarea como `done`.
# No requiere python3 en el host; la verificación del arnés corre en Docker.

set -u
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

ok()    { printf "${GREEN}[OK]${NC}    %s\n" "$1"; }
warn()  { printf "${YELLOW}[WARN]${NC}  %s\n" "$1"; }
fail()  { printf "${RED}[FAIL]${NC}  %s\n" "$1"; }

EXIT_CODE=0
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1
COMPOSE_FILE="docker/docker-compose.yml"

# Cargar .env opcional
if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  . ./.env
  set +a
fi

echo "── 1. Sistema operativo ────────────────────────────────"

case "$(uname -s)" in
  Linux)
    ok "SO -> linux ($(uname -r))"
    ;;
  Darwin)
    ok "SO -> macos ($(sw_vers -productVersion 2>/dev/null || uname -r))"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    ok "SO -> windows-bash ($(uname -s))"
    warn "En Windows se recomienda WSL2 para mejor compatibilidad con Docker"
    ;;
  *)
    fail "SO desconocido: $(uname -s)"
    EXIT_CODE=1
    ;;
esac

echo ""
echo "── 2. Docker ───────────────────────────────────────────"

if ! command -v docker >/dev/null 2>&1; then
  fail "docker no está instalado"
  exit 1
fi
ok "docker -> $(docker --version)"

if ! docker info >/dev/null 2>&1; then
  fail "Docker daemon no responde. ¿Está Docker Desktop en ejecución?"
  exit 1
fi
ok "Docker daemon activo"

if docker compose version >/dev/null 2>&1; then
  ok "docker compose -> $(docker compose version 2>/dev/null | head -1)"
elif command -v docker-compose >/dev/null 2>&1; then
  ok "docker-compose -> $(docker-compose --version)"
  warn "Usa el plugin 'docker compose' cuando sea posible"
else
  fail "docker compose no está disponible"
  exit 1
fi

echo ""
echo "── 3. Git ──────────────────────────────────────────────"

if ! command -v git >/dev/null 2>&1; then
  fail "git no está instalado"
  exit 1
fi
ok "git -> $(git --version)"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  fail "No estás dentro de un repositorio git"
  EXIT_CODE=1
else
  ok "Directorio es un repositorio git"
fi

GIT_NAME="$(git config user.name 2>/dev/null || true)"
GIT_EMAIL="$(git config user.email 2>/dev/null || true)"
if [ -z "$GIT_NAME" ] || [ -z "$GIT_EMAIL" ]; then
  fail "Configura git user.name y user.email (global o local)"
  EXIT_CODE=1
else
  ok "git user -> $GIT_NAME <$GIT_EMAIL>"
fi

echo ""
echo "── 4. GitHub CLI ───────────────────────────────────────"

if ! command -v gh >/dev/null 2>&1; then
  fail "gh (GitHub CLI) no está instalado. Instala desde https://cli.github.com/"
  exit 1
fi
ok "gh -> $(gh --version | head -1)"

if ! gh auth status >/dev/null 2>&1; then
  fail "No hay sesión GitHub activa. Ejecuta: gh auth login"
  exit 1
fi
ok "gh auth -> sesión activa"

if [ -n "${GITHUB_EXPECTED_USER:-}" ]; then
  ACTUAL_USER="$(gh api user -q .login 2>/dev/null || true)"
  if [ "$ACTUAL_USER" != "$GITHUB_EXPECTED_USER" ]; then
    fail "Usuario GitHub esperado '$GITHUB_EXPECTED_USER', actual '$ACTUAL_USER'"
    EXIT_CODE=1
  else
    ok "GitHub user -> $ACTUAL_USER (coincide con GITHUB_EXPECTED_USER)"
  fi
else
  ACTUAL_USER="$(gh api user -q .login 2>/dev/null || true)"
  ok "GitHub user -> ${ACTUAL_USER:-desconocido}"
fi

echo ""
echo "── 5. Archivos base del arnés ──────────────────────────"

for f in AGENTS.md feature_list.json progress/current.md docs/architecture.md docs/conventions.md docs/verification.md CHECKPOINTS.md; do
  if [ ! -f "$f" ]; then
    fail "Falta archivo base: $f"
    EXIT_CODE=1
  else
    ok "Existe $f"
  fi
done

if [ ! -f "$COMPOSE_FILE" ]; then
  fail "Falta $COMPOSE_FILE"
  exit 1
fi

echo ""
echo "── 6. Verificación en contenedor ───────────────────────"

if [ $EXIT_CODE -ne 0 ]; then
  fail "Checks del host fallaron; no se ejecuta verify en contenedor"
  exit 1
fi

echo "Construyendo imagen harness si hace falta..."
if ! docker compose -f "$COMPOSE_FILE" build harness; then
  fail "docker compose build harness falló"
  exit 1
fi

if docker compose -f "$COMPOSE_FILE" run --rm harness ./docker/scripts/verify.sh; then
  ok "Verificación en contenedor completada"
else
  fail "Verificación en contenedor falló"
  EXIT_CODE=1
fi

echo ""
echo "── 7. Resumen ──────────────────────────────────────────"

if [ $EXIT_CODE -eq 0 ]; then
  ok "Entorno listo. Puedes empezar a trabajar."
else
  fail "Entorno NO está listo. Resuelve los errores antes de avanzar."
fi

exit $EXIT_CODE
