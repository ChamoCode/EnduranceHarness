#!/usr/bin/env bash
# docker/scripts/verify.sh — Validación del arnés (ejecutar dentro del contenedor harness)
#
# Salida: bloques [OK]/[FAIL]. Exit 0 si todo pasa.

set -u
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

ok()    { printf "${GREEN}[OK]${NC}    %s\n" "$1"; }
warn()  { printf "${YELLOW}[WARN]${NC}  %s\n" "$1"; }
fail()  { printf "${RED}[FAIL]${NC}  %s\n" "$1"; }

EXIT_CODE=0
ROOT="${ROOT:-/workspace}"
cd "$ROOT" || { fail "No se puede cd a $ROOT"; exit 1; }

echo "── 1. Archivos base del arnés ──────────────────────────"

BASE_FILES=(
  AGENTS.md
  feature_list.json
  progress/current.md
  docs/architecture.md
  docs/conventions.md
  docs/verification.md
  CHECKPOINTS.md
)

for f in "${BASE_FILES[@]}"; do
  if [ ! -f "$f" ]; then
    fail "Falta archivo base: $f"
    EXIT_CODE=1
  else
    ok "Existe $f"
  fi
done

echo ""
echo "── 2. Validando feature_list.json y specs ─────────────"

python3 - <<'PY'
import json, os, sys
try:
    data = json.load(open("feature_list.json"))
    valid = {"pending", "spec_ready", "in_progress", "done", "blocked"}
    in_progress = [f for f in data["features"] if f["status"] == "in_progress"]
    if len(in_progress) > 1:
        print(f"[FAIL]  Hay {len(in_progress)} features en in_progress (máximo 1)")
        sys.exit(1)
    requires_spec = {"spec_ready", "in_progress", "done"}
    spec_errors = []
    for f in data["features"]:
        if f["status"] not in valid:
            print(f"[FAIL]  Estado inválido en feature {f['id']}: {f['status']}")
            sys.exit(1)
        if f.get("sdd") and f["status"] in requires_spec:
            spec_dir = os.path.join("specs", f["name"])
            for fname in ("requirements.md", "design.md", "tasks.md"):
                if not os.path.isfile(os.path.join(spec_dir, fname)):
                    spec_errors.append(
                        f"feature {f['id']} ({f['name']}) en {f['status']} "
                        f"sin {spec_dir}/{fname}"
                    )
    if spec_errors:
        for e in spec_errors:
            print(f"[FAIL]  {e}")
        sys.exit(1)
    print(f"[OK]    feature_list.json válido ({len(data['features'])} features)")
    print(f"[OK]    Specs presentes para features sdd con estado no-pending")
except SystemExit:
    raise
except Exception as e:
    print(f"[FAIL]  feature_list.json o specs inválidos: {e}")
    sys.exit(1)
PY

if [ $? -ne 0 ]; then EXIT_CODE=1; fi

echo ""
echo "── 3. Infraestructura Docker ───────────────────────────"

for f in docker/Dockerfile.harness docker/Dockerfile.product docker/docker-compose.yml docker/scripts/verify.sh docker/scripts/product-build.sh docker/scripts/product-test.sh; do
  if [ ! -f "$f" ]; then
    fail "Falta $f"
    EXIT_CODE=1
  else
    ok "Existe $f"
  fi
done

for d in product tests product/backend product/frontend tests/backend tests/frontend; do
  if [ ! -d "$d" ]; then
    fail "Falta directorio $d/"
    EXIT_CODE=1
  else
    ok "Existe $d/"
  fi
done

echo ""
echo "── 4. Tests del arnés (opcional) ─────────────────────"

if [ -d "tests-harness" ]; then
  if python3 -m unittest discover -s tests-harness -v 2>&1; then
    ok "Todos los tests-harness pasan"
  else
    fail "Hay tests-harness rotos"
    EXIT_CODE=1
  fi
else
  warn "Carpeta tests-harness/ no existe (opcional)"
fi

echo ""
echo "── 5. Resumen ──────────────────────────────────────────"

if [ $EXIT_CODE -eq 0 ]; then
  ok "Verificación del arnés completada."
else
  fail "Verificación del arnés falló."
fi

exit $EXIT_CODE
