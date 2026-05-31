# endurance-init.ps1 — Scaffold projects from Endurance Harness Engineering plugin
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
        Write-Fail "$TargetPath is not empty. Use -Force to continue."
    }
} else {
    New-Item -ItemType Directory -Path $TargetPath -Force | Out-Null
}

$ProjectDesc = "Project $Name scaffolded with Endurance Harness Engineering plugin."

if ($Full) {
    $TemplateDir = Join-Path $PluginRoot "templates\project"
    Write-Ok "Full mode — copying template from $TemplateDir"
    Copy-Item -Path (Join-Path $TemplateDir "*") -Destination $TargetPath -Recurse -Force

    foreach ($tmpl in @("AGENTS.md", "CLAUDE.md")) {
        $t = Join-Path $TargetPath "$tmpl.template"
        if (Test-Path $t) {
            $d = Join-Path $TargetPath $tmpl
            Copy-Item $t $d -Force
            Replace-Placeholders $d $Name $ProjectDesc
            Remove-Item $t -Force
        }
    }

    $t = Join-Path $TargetPath "feature_list.json.template"
    if (Test-Path $t) {
        $d = Join-Path $TargetPath "feature_list.json"
        Copy-Item $t $d -Force
        Replace-Placeholders $d $Name $ProjectDesc
        Remove-Item $t -Force
    }

    $hooksSrc = Join-Path $PluginRoot "hooks\hooks.json.template"
    if (Test-Path $hooksSrc) {
        $claudeDir = Join-Path $TargetPath ".claude"
        New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
        Copy-Item $hooksSrc (Join-Path $claudeDir "settings.json") -Force
    }
    $nextSteps = @(
        "  1. cd $TargetPath",
        "  2. Install plugin endurance-harness-engineering",
        "  3. ./init.ps1",
        "  4. Use skill feature-list to define backlog with complexity",
        "  5. 'Implement the next pending feature'"
    )
} else {
    $TemplateDir = Join-Path $PluginRoot "templates\lite"
    Write-Ok "Lite mode — creating tracking structure in $TargetPath"

    New-Item -ItemType Directory -Force -Path (Join-Path $TargetPath "specs")    | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $TargetPath "progress") | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $TargetPath ".claude")  | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $TargetPath ".cursor")  | Out-Null

    $progressSrc = Join-Path $PluginRoot "templates\project\progress"
    if (Test-Path $progressSrc) {
        Copy-Item (Join-Path $progressSrc "current.md") (Join-Path $TargetPath "progress\current.md") -Force
        Copy-Item (Join-Path $progressSrc "history.md") (Join-Path $TargetPath "progress\history.md") -Force -ErrorAction SilentlyContinue
    }

    $modelsSrc = Join-Path $PluginRoot "templates\project\models.config.json"
    if (Test-Path $modelsSrc) {
        Copy-Item $modelsSrc (Join-Path $TargetPath "models.config.json") -Force
    }

    foreach ($tmpl in @("AGENTS.md", "CLAUDE.md")) {
        $t = Join-Path $TemplateDir "$tmpl.template"
        if (Test-Path $t) {
            $d = Join-Path $TargetPath $tmpl
            Copy-Item $t $d -Force
            Replace-Placeholders $d $Name $ProjectDesc
        }
    }

    $t = Join-Path $TemplateDir "feature_list.json.template"
    if (Test-Path $t) {
        $d = Join-Path $TargetPath "feature_list.json"
        Copy-Item $t $d -Force
        Replace-Placeholders $d $Name $ProjectDesc
    }

    $hooksSrc = Join-Path $PluginRoot "hooks\hooks-lite.json.template"
    if (Test-Path $hooksSrc) {
        Copy-Item $hooksSrc (Join-Path $TargetPath ".claude\settings.json") -Force
    }

    @"
# Cursor — plugin endurance-harness-engineering

Install from Plugin Marketplace or copy to ~/.cursor/plugins/local/endurance-harness-engineering
"@ | Set-Content (Join-Path $TargetPath ".cursor\README.md") -Encoding UTF8

    $nextSteps = @(
        "  1. cd $TargetPath",
        "  2. Install plugin endurance-harness-engineering",
        "  3. Use skill feature-list to define backlog (complexity and tdd)",
        "  4. 'Implement the next pending feature'"
    )
}

if ($Full) {
    $cursorDir = Join-Path $TargetPath ".cursor"
    New-Item -ItemType Directory -Path $cursorDir -Force | Out-Null
    @"
# Cursor — plugin endurance-harness-engineering

Install from Plugin Marketplace or copy to ~/.cursor/plugins/local/endurance-harness-engineering
"@ | Set-Content (Join-Path $cursorDir "README.md") -Encoding UTF8
}

if ($GitInit) {
    Push-Location $TargetPath
    git init
    Pop-Location
    Write-Ok "git init in $TargetPath"
}

Write-Host ""
Write-Ok "Project scaffolded at: $TargetPath"
$modeLabel = if ($Full) { "(full mode)" } else { "(lite mode)" }
Write-Host "  Mode: $modeLabel" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:"
$nextSteps | ForEach-Object { Write-Host $_ }
