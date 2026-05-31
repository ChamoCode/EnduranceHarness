# Validacion estructural del plugin (sin Docker)
$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent
$errors = @()

$required = @(
    ".cursor-plugin/plugin.json",
    ".claude-plugin/plugin.json",
    "agents/leader.md",
    "skills/feature-list/SKILL.md",
    "skills/model-routing/SKILL.md",
    "skills/agent-author/SKILL.md",
    "rules/leader-role.mdc",
    "rules/sdd-protocol.mdc",
    "hooks/hooks.json.template",
    "bin/r2d2-init.ps1",
    "bin/r2d2-init.sh",
    "templates/project/models.config.json",
    "templates/project/feature_list.json.template",
    "templates/project/docker/docker-compose.yml"
)

foreach ($f in $required) {
    if (-not (Test-Path (Join-Path $Root $f))) {
        $errors += "Falta: $f"
    }
}

$agentCount = (Get-ChildItem (Join-Path $Root "agents\*.md")).Count
if ($agentCount -lt 9) {
    $errors += "Se esperan 9 agentes, hay $agentCount"
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Host "[FAIL] $_" -ForegroundColor Red }
    exit 1
}

Write-Host "[OK] Estructura del plugin valida ($agentCount agentes)" -ForegroundColor Green
exit 0
