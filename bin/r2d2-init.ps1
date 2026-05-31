# r2d2-init.ps1 — Scaffold de proyecto R2D2-Harness desde el plugin
param(
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [Parameter(Mandatory = $true)]
    [string]$Path,
    [switch]$Force,
    [switch]$GitInit,
    [switch]$Full
)

$ErrorActionPreference = "Stop"
$PluginRoot = Split-Path $PSScriptRoot -Parent
$TargetPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)

function Write-Ok($msg)   { Write-Host "[OK]    $msg" -ForegroundColor Green }
function Write-Fail($msg) { Write-Host "[FAIL]  $msg" -ForegroundColor Red; exit 1 }

function Replace-Placeholders {
    param([string]$FilePath, [string]$ProjectName, [string]$ProjectDesc)
    if (-not (Test-Path $FilePath)) { return }
    $content = Get-Content $FilePath -Raw -Encoding UTF8
    $content = $content -replace '\{\{PROJECT_NAME\}\}', $ProjectName
    $content = $content -replace '\{\{PROJECT_DESCRIPTION\}\}', $ProjectDesc
    Set-Content -Path $FilePath -Value $content -Encoding UTF8 -NoNewline
}

if (Test-Path $TargetPath) {
    $items = Get-ChildItem $TargetPath -Force -ErrorAction SilentlyContinue
    if ($items.Count -gt 0 -and -not $Force) {
        Write-Fail "$TargetPath no esta vacio. Usa -Force para continuar."
    }
} else {
    New-Item -ItemType Directory -Path $TargetPath -Force | Out-Null
}

$ProjectDesc = "Proyecto $Name scaffoldado con R2D2-Harness plugin."

if ($Full) {
    # ── Modo completo (docker, docs, product, tests) ───────────────────────
    $TemplateDir = Join-Path $PluginRoot "templates\project"
    Write-Ok "Modo completo — copiando plantilla desde $TemplateDir"
    Copy-Item -Path (Join-Path $TemplateDir "*") -Destination $TargetPath -Recurse -Force

    # AGENTS.md
    $t = Join-Path $TargetPath "AGENTS.md.template"
    if (Test-Path $t) {
        $d = Join-Path $TargetPath "AGENTS.md"
        Copy-Item $t $d -Force
        Replace-Placeholders $d $Name $ProjectDesc
        Remove-Item $t -Force
    }
    # CLAUDE.md
    $t = Join-Path $TargetPath "CLAUDE.md.template"
    if (Test-Path $t) {
        $d = Join-Path $TargetPath "CLAUDE.md"
        Copy-Item $t $d -Force
        Replace-Placeholders $d $Name $ProjectDesc
        Remove-Item $t -Force
    }
    # feature_list.json
    $t = Join-Path $TargetPath "feature_list.json.template"
    if (Test-Path $t) {
        $d = Join-Path $TargetPath "feature_list.json"
        Copy-Item $t $d -Force
        Replace-Placeholders $d $Name $ProjectDesc
        Remove-Item $t -Force
    }
    # hooks -> .claude/settings.json
    $hooksSrc = Join-Path $PluginRoot "hooks\hooks.json.template"
    if (Test-Path $hooksSrc) {
        $claudeDir = Join-Path $TargetPath ".claude"
        New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
        Copy-Item $hooksSrc (Join-Path $claudeDir "settings.json") -Force
    }
    $nextSteps = @(
        "  1. cd $TargetPath",
        "  2. Instala plugin r2d2-harness",
        "  3. ./init.ps1",
        "  4. Usa skill feature-list para definir backlog con complexity",
        "  5. 'Implementa la siguiente feature pendiente'"
    )
} else {
    # ── Modo ligero (solo tracking) ────────────────────────────────────────
    $TemplateDir = Join-Path $PluginRoot "templates\lite"
    Write-Ok "Modo ligero — creando estructura de tracking en $TargetPath"

    # Carpetas de tracking
    New-Item -ItemType Directory -Force -Path (Join-Path $TargetPath "specs")    | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $TargetPath "progress") | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $TargetPath ".claude")  | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $TargetPath ".cursor")  | Out-Null

    # progress/current.md y history.md
    $progressSrc = Join-Path $PluginRoot "templates\project\progress"
    if (Test-Path $progressSrc) {
        Copy-Item (Join-Path $progressSrc "current.md") (Join-Path $TargetPath "progress\current.md") -Force
        Copy-Item (Join-Path $progressSrc "history.md") (Join-Path $TargetPath "progress\history.md") -Force -ErrorAction SilentlyContinue
    }

    # models.config.json
    $modelsSrc = Join-Path $PluginRoot "templates\project\models.config.json"
    if (Test-Path $modelsSrc) {
        Copy-Item $modelsSrc (Join-Path $TargetPath "models.config.json") -Force
    }

    # AGENTS.md desde lite template
    $t = Join-Path $TemplateDir "AGENTS.md.template"
    if (Test-Path $t) {
        $d = Join-Path $TargetPath "AGENTS.md"
        Copy-Item $t $d -Force
        Replace-Placeholders $d $Name $ProjectDesc
    }

    # CLAUDE.md desde lite template
    $t = Join-Path $TemplateDir "CLAUDE.md.template"
    if (Test-Path $t) {
        $d = Join-Path $TargetPath "CLAUDE.md"
        Copy-Item $t $d -Force
        Replace-Placeholders $d $Name $ProjectDesc
    }

    # feature_list.json desde lite template
    $t = Join-Path $TemplateDir "feature_list.json.template"
    if (Test-Path $t) {
        $d = Join-Path $TargetPath "feature_list.json"
        Copy-Item $t $d -Force
        Replace-Placeholders $d $Name $ProjectDesc
    }

    # hooks ligeros -> .claude/settings.json
    $hooksSrc = Join-Path $PluginRoot "hooks\hooks-lite.json.template"
    if (Test-Path $hooksSrc) {
        Copy-Item $hooksSrc (Join-Path $TargetPath ".claude\settings.json") -Force
    }

    # .cursor readme
    @"
# Cursor — plugin r2d2-harness

Instala el plugin r2d2-harness desde Plugin Marketplace o copia a ~/.cursor/plugins/local/r2d2-harness
"@ | Set-Content (Join-Path $TargetPath ".cursor\README.md") -Encoding UTF8

    $nextSteps = @(
        "  1. cd $TargetPath",
        "  2. Instala plugin r2d2-harness",
        "  3. Usa skill feature-list para definir backlog (con complexity y tdd si aplica)",
        "  4. 'Implementa la siguiente feature pendiente'"
    )
}

# .cursor README (modo completo tambien)
if ($Full) {
    $cursorDir = Join-Path $TargetPath ".cursor"
    New-Item -ItemType Directory -Path $cursorDir -Force | Out-Null
    @"
# Cursor — plugin r2d2-harness

Instala el plugin r2d2-harness desde Plugin Marketplace o copia a ~/.cursor/plugins/local/r2d2-harness
"@ | Set-Content (Join-Path $cursorDir "README.md") -Encoding UTF8
}

if ($GitInit) {
    Push-Location $TargetPath
    git init
    Pop-Location
    Write-Ok "git init en $TargetPath"
}

Write-Host ""
Write-Ok "Proyecto scaffoldado en: $TargetPath"
$modeLabel = if ($Full) { "(modo completo)" } else { "(modo ligero)" }
Write-Host "  Modo: $modeLabel" -ForegroundColor Cyan
Write-Host ""
Write-Host "Proximos pasos:"
$nextSteps | ForEach-Object { Write-Host $_ }
