#!/usr/bin/env bash
# Ejecuta tests del producto dentro del contenedor (invocado por servicio test)
set -u

if find tests -name 'test_*.py' -print -quit 2>/dev/null | grep -q .; then
  echo "[OK]    Ejecutando tests en tests/"
  exec python3 -m unittest discover -s tests -v
elif find tests/backend tests/frontend -name 'test_*.py' -print -quit 2>/dev/null | grep -q .; then
  echo "[OK]    Ejecutando tests en tests/backend y tests/frontend"
  FAILED=0
  for dir in tests/backend tests/frontend; do
    if find "$dir" -name 'test_*.py' -print -quit 2>/dev/null | grep -q .; then
      python3 -m unittest discover -s "$dir" -v || FAILED=1
    fi
  done
  exit $FAILED
else
  echo "[WARN]  No hay tests en tests/ todavia (plantilla vacia)"
  exit 0
fi
