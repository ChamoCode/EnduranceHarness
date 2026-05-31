#!/usr/bin/env bash
# endurance-init.sh — Scaffold projects from Endurance Harness Engineering plugin
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_NAME=""
TARGET_PATH=""
FORCE=false
GIT_INIT=false
FULL=false

usage() {
  cat <<EOF
Usage: endurance init --name <name> --path <directory> [options]

  --name       Project identifier (snake_case or kebab-case)
  --path       Destination directory (created if missing; can be .)
  --force      Overwrite non-empty destination
  --git-init   Run git init in destination
  --full       Full mode: copies docker/, docs/, product/, tests/, init scripts
               (default: specs/, progress/ and tracking files only)
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
    *) echo "Unknown option: $1"; usage ;;
  esac
done

[[ -n "$PROJECT_NAME" && -n "$TARGET_PATH" ]] || usage

TARGET_PATH="$(cd "$(dirname "$TARGET_PATH")" 2>/dev/null && pwd)/$(basename "$TARGET_PATH")" || \
  TARGET_PATH="$(realpath -m "$TARGET_PATH" 2>/dev/null || echo "$TARGET_PATH")"

if [[ -d "$TARGET_PATH" ]]; then
  if [[ "$FORCE" != true ]] && [[ -n "$(ls -A "$TARGET_PATH" 2>/dev/null)" ]]; then
    echo "[FAIL]  $TARGET_PATH is not empty. Use --force to continue."
    exit 1
  fi
else
  mkdir -p "$TARGET_PATH"
fi

PROJECT_DESC="Project $PROJECT_NAME scaffolded with Endurance Harness Engineering plugin."

replace_placeholders() {
  local f="$1"
  [[ -f "$f" ]] || return 0
  sed -i.bak "s/{{PROJECT_NAME}}/$PROJECT_NAME/g; s/{{PROJECT_DESCRIPTION}}/$PROJECT_DESC/g" "$f" 2>/dev/null || \
  sed -i '' "s/{{PROJECT_NAME}}/$PROJECT_NAME/g; s/{{PROJECT_DESCRIPTION}}/$PROJECT_DESC/g" "$f" 2>/dev/null || true
  rm -f "${f}.bak" 2>/dev/null || true
}

if [[ "$FULL" == true ]]; then
  TEMPLATE_DIR="$PLUGIN_ROOT/templates/project"
  echo "[OK]    Full mode — copying template from $TEMPLATE_DIR"
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
  2. Install plugin endurance-harness-engineering
  3. ./init.sh  (or ./init.ps1 on Windows)
  4. Use skill feature-list to define backlog with complexity
  5. 'Implement the next pending feature'"

else
  TEMPLATE_DIR="$PLUGIN_ROOT/templates/lite"
  echo "[OK]    Lite mode — creating tracking structure in $TARGET_PATH"

  mkdir -p "$TARGET_PATH/specs" "$TARGET_PATH/progress" "$TARGET_PATH/.claude" "$TARGET_PATH/.cursor"

  PROG_SRC="$PLUGIN_ROOT/templates/project/progress"
  [[ -f "$PROG_SRC/current.md" ]] && cp "$PROG_SRC/current.md" "$TARGET_PATH/progress/current.md"
  [[ -f "$PROG_SRC/history.md" ]] && cp "$PROG_SRC/history.md" "$TARGET_PATH/progress/history.md"

  [[ -f "$PLUGIN_ROOT/templates/project/models.config.json" ]] && \
    cp "$PLUGIN_ROOT/templates/project/models.config.json" "$TARGET_PATH/models.config.json"

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

  HOOKS_SRC="$PLUGIN_ROOT/hooks/hooks-lite.json.template"
  [[ -f "$HOOKS_SRC" ]] && cp "$HOOKS_SRC" "$TARGET_PATH/.claude/settings.json"

  cat > "$TARGET_PATH/.cursor/README.md" <<EOF
# Cursor — plugin endurance-harness-engineering

Install from Plugin Marketplace or copy to ~/.cursor/plugins/local/endurance-harness-engineering
EOF

  NEXT_STEPS="  1. cd $TARGET_PATH
  2. Install plugin endurance-harness-engineering
  3. Use skill feature-list to define backlog (complexity and tdd)
  4. 'Implement the next pending feature'"
fi

if [[ "$GIT_INIT" == true ]]; then
  (cd "$TARGET_PATH" && git init)
  echo "[OK]    git init in $TARGET_PATH"
fi

MODE_LABEL="$([ "$FULL" == true ] && echo "full" || echo "lite")"

cat <<EOF

[OK]    Project scaffolded at: $TARGET_PATH
        Mode: $MODE_LABEL

Next steps:
$NEXT_STEPS
EOF
