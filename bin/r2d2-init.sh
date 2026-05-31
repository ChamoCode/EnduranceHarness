#!/usr/bin/env bash
# r2d2-init.sh — Scaffold de proyecto R2D2-Harness desde el plugin
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_NAME=""
TARGET_PATH=""
FORCE=false
GIT_INIT=false
FULL=false

usage() {
  cat <<EOF
Uso: r2d2 init --name <nombre> --path <directorio> [opciones]

  --name       Identificador del proyecto (snake_case o kebab-case)
  --path       Directorio destino (se crea si no existe; puede ser .)
  --force      Sobrescribe archivos en destino no vacio
  --git-init   Ejecuta git init en el destino
  --full       Modo completo: copia docker/, docs/, product/, tests/, init scripts
               (por defecto crea solo specs/, progress/ y archivos de tracking)
EOF
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    init) shift ;;
    --name) PROJECT_NAME="$2"; shift 2 ;;
    --path) TARGET_PATH="$2"; shift 2 ;;
    --force) FORCE=true; shift ;;
    --git-init) GIT_INIT=true; shift ;;
    --full) FULL=true; shift ;;
    -h|--help) usage ;;
    *) echo "Opcion desconocida: $1"; usage ;;
  esac
done

[[ -n "$PROJECT_NAME" && -n "$TARGET_PATH" ]] || usage

TARGET_PATH="$(cd "$(dirname "$TARGET_PATH")" 2>/dev/null && pwd)/$(basename "$TARGET_PATH")" || \
  TARGET_PATH="$(realpath -m "$TARGET_PATH" 2>/dev/null || echo "$TARGET_PATH")"

if [[ -d "$TARGET_PATH" ]]; then
  if [[ "$FORCE" != true ]] && [[ -n "$(ls -A "$TARGET_PATH" 2>/dev/null)" ]]; then
    echo "[FAIL]  $TARGET_PATH no esta vacio. Usa --force para continuar."
    exit 1
  fi
else
  mkdir -p "$TARGET_PATH"
fi

PROJECT_DESC="Proyecto $PROJECT_NAME scaffoldado con R2D2-Harness plugin."

replace_placeholders() {
  local f="$1"
  [[ -f "$f" ]] || return 0
  sed -i.bak "s/{{PROJECT_NAME}}/$PROJECT_NAME/g; s/{{PROJECT_DESCRIPTION}}/$PROJECT_DESC/g" "$f" 2>/dev/null || \
  sed -i '' "s/{{PROJECT_NAME}}/$PROJECT_NAME/g; s/{{PROJECT_DESCRIPTION}}/$PROJECT_DESC/g" "$f" 2>/dev/null || true
  rm -f "${f}.bak" 2>/dev/null || true
}

if [[ "$FULL" == true ]]; then
  # ── Modo completo (docker, docs, product, tests) ─────────────────────
  TEMPLATE_DIR="$PLUGIN_ROOT/templates/project"
  echo "[OK]    Modo completo — copiando plantilla desde $TEMPLATE_DIR"
  cp -R "$TEMPLATE_DIR/." "$TARGET_PATH/"

  for tmpl in AGENTS.md CLAUDE.md; do
    if [[ -f "$TARGET_PATH/${tmpl}.template" ]]; then
      cp "$TARGET_PATH/${tmpl}.template" "$TARGET_PATH/$tmpl"
      replace_placeholders "$TARGET_PATH/$tmpl"
      rm -f "$TARGET_PATH/${tmpl}.template"
    fi
  done

  if [[ -f "$TARGET_PATH/feature_list.json.template" ]]; then
    cp "$TARGET_PATH/feature_list.json.template" "$TARGET_PATH/feature_list.json"
    replace_placeholders "$TARGET_PATH/feature_list.json"
    rm -f "$TARGET_PATH/feature_list.json.template"
  fi

  HOOKS_SRC="$PLUGIN_ROOT/hooks/hooks.json.template"
  if [[ -f "$HOOKS_SRC" ]]; then
    mkdir -p "$TARGET_PATH/.claude"
    cp "$HOOKS_SRC" "$TARGET_PATH/.claude/settings.json"
  fi

  NEXT_STEPS="  1. cd $TARGET_PATH
  2. Instala plugin r2d2-harness
  3. ./init.sh  (o ./init.ps1 en Windows)
  4. Usa skill feature-list para definir backlog con complexity
  5. 'Implementa la siguiente feature pendiente'"

else
  # ── Modo ligero (solo tracking) ──────────────────────────────────────
  TEMPLATE_DIR="$PLUGIN_ROOT/templates/lite"
  echo "[OK]    Modo ligero — creando estructura de tracking en $TARGET_PATH"

  mkdir -p "$TARGET_PATH/specs"
  mkdir -p "$TARGET_PATH/progress"
  mkdir -p "$TARGET_PATH/.claude"
  mkdir -p "$TARGET_PATH/.cursor"

  # progress files
  PROG_SRC="$PLUGIN_ROOT/templates/project/progress"
  [[ -f "$PROG_SRC/current.md" ]] && cp "$PROG_SRC/current.md" "$TARGET_PATH/progress/current.md"
  [[ -f "$PROG_SRC/history.md" ]] && cp "$PROG_SRC/history.md" "$TARGET_PATH/progress/history.md"

  # models.config.json
  [[ -f "$PLUGIN_ROOT/templates/project/models.config.json" ]] && \
    cp "$PLUGIN_ROOT/templates/project/models.config.json" "$TARGET_PATH/models.config.json"

  # AGENTS.md, CLAUDE.md, feature_list.json desde lite template
  for tmpl in AGENTS.md CLAUDE.md; do
    if [[ -f "$TEMPLATE_DIR/${tmpl}.template" ]]; then
      cp "$TEMPLATE_DIR/${tmpl}.template" "$TARGET_PATH/$tmpl"
      replace_placeholders "$TARGET_PATH/$tmpl"
    fi
  done

  if [[ -f "$TEMPLATE_DIR/feature_list.json.template" ]]; then
    cp "$TEMPLATE_DIR/feature_list.json.template" "$TARGET_PATH/feature_list.json"
    replace_placeholders "$TARGET_PATH/feature_list.json"
  fi

  # hooks ligeros
  HOOKS_SRC="$PLUGIN_ROOT/hooks/hooks-lite.json.template"
  [[ -f "$HOOKS_SRC" ]] && cp "$HOOKS_SRC" "$TARGET_PATH/.claude/settings.json"

  cat > "$TARGET_PATH/.cursor/README.md" <<EOF
# Cursor — plugin r2d2-harness

Instala el plugin r2d2-harness desde Plugin Marketplace o copia a ~/.cursor/plugins/local/r2d2-harness
EOF

  NEXT_STEPS="  1. cd $TARGET_PATH
  2. Instala plugin r2d2-harness
  3. Usa skill feature-list para definir backlog (con complexity y tdd si aplica)
  4. 'Implementa la siguiente feature pendiente'"
fi

if [[ "$GIT_INIT" == true ]]; then
  (cd "$TARGET_PATH" && git init)
  echo "[OK]    git init en $TARGET_PATH"
fi

MODE_LABEL="$([ "$FULL" == true ] && echo "completo" || echo "ligero")"

cat <<EOF

[OK]    Proyecto scaffoldado en: $TARGET_PATH
        Modo: $MODE_LABEL

Proximos pasos:
$NEXT_STEPS
EOF
