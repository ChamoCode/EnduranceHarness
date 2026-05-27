# init.ps1 - Verificacion e inicializacion del entorno (host + contenedor)
#
# Equivalente PowerShell de init.sh para Windows nativo.
# No requiere python3 en el host.

$ErrorActionPreference = "Continue"
$ExitCode = 0
$ComposeFile = "docker/docker-compose.yml"

function Write-Ok($msg)   { Write-Host "[OK]    $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "[WARN]  $msg" -ForegroundColor Yellow }
function Write-Fail($msg) { Write-Host "[FAIL]  $msg" -ForegroundColor Red }

Set-Location $PSScriptRoot

# Cargar .env opcional
if (Test-Path ".env") {
    Get-Content ".env" | ForEach-Object {
        if ($_ -match '^\s*([^#=]+)=(.*)$') {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim().Trim('"').Trim("'")
            Set-Item -Path "env:$name" -Value $value
        }
    }
}

Write-Host "-- 1. Sistema operativo --------------------------------"
Write-Ok "SO -> windows-powershell ($($PSVersionTable.PSVersion))"
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Fail "Se requiere PowerShell 5.1 o superior"
    exit 1
}

Write-Host ""
Write-Host "-- 2. Docker -------------------------------------------"
try {
    $dockerVer = docker --version 2>&1
    Write-Ok "docker -> $dockerVer"
} catch {
    Write-Fail "docker no esta instalado"
    exit 1
}

docker info *>$null
if ($LASTEXITCODE -ne 0) {
    Write-Fail "Docker daemon no responde. Esta Docker Desktop en ejecucion?"
    exit 1
}
Write-Ok "Docker daemon activo"

docker compose version *>$null
if ($LASTEXITCODE -ne 0) {
    Write-Fail "docker compose no esta disponible"
    exit 1
}
Write-Ok "docker compose disponible"

Write-Host ""
Write-Host "-- 3. Git ----------------------------------------------"
try {
    $gitVer = git --version 2>&1
    Write-Ok "git -> $gitVer"
} catch {
    Write-Fail "git no esta instalado"
    exit 1
}

git rev-parse --is-inside-work-tree 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Fail "No estas dentro de un repositorio git"
    $ExitCode = 1
} else {
    Write-Ok "Directorio es un repositorio git"
}

$gitName = git config user.name 2>$null
$gitEmail = git config user.email 2>$null
if (-not $gitName -or -not $gitEmail) {
    Write-Fail "Configura git user.name y user.email (global o local)"
    $ExitCode = 1
} else {
    Write-Ok "git user -> $gitName ($gitEmail)"
}

Write-Host ""
Write-Host "-- 4. GitHub CLI ---------------------------------------"
try {
    $ghVer = gh --version 2>&1 | Select-Object -First 1
    Write-Ok "gh -> $ghVer"
} catch {
    Write-Fail "gh (GitHub CLI) no esta instalado. Instala desde https://cli.github.com/"
    exit 1
}

gh auth status 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Fail "No hay sesion GitHub activa. Ejecuta: gh auth login"
    exit 1
}
Write-Ok "gh auth -> sesion activa"

$expectedUser = $env:GITHUB_EXPECTED_USER
$actualUser = gh api user -q .login 2>$null
if ($expectedUser -and $actualUser -ne $expectedUser) {
    Write-Fail "Usuario GitHub esperado '$expectedUser', actual '$actualUser'"
    $ExitCode = 1
} elseif ($actualUser) {
    if ($expectedUser) {
        Write-Ok "GitHub user -> $actualUser (coincide con GITHUB_EXPECTED_USER)"
    } else {
        Write-Ok "GitHub user -> $actualUser"
    }
} else {
    Write-Warn "No se pudo obtener login de GitHub"
}

Write-Host ""
Write-Host "-- 5. Archivos base del arnes --------------------------"
$baseFiles = @(
    "AGENTS.md", "feature_list.json", "progress/current.md",
    "docs/architecture.md", "docs/conventions.md", "docs/verification.md",
    "CHECKPOINTS.md"
)
foreach ($f in $baseFiles) {
    if (-not (Test-Path $f)) {
        Write-Fail "Falta archivo base: $f"
        $ExitCode = 1
    } else {
        Write-Ok "Existe $f"
    }
}

if (-not (Test-Path $ComposeFile)) {
    Write-Fail "Falta $ComposeFile"
    exit 1
}

Write-Host ""
Write-Host "-- 6. Verificacion en contenedor -----------------------"
if ($ExitCode -ne 0) {
    Write-Fail "Checks del host fallaron; no se ejecuta verify en contenedor"
    exit 1
}

Write-Host "Construyendo imagen harness si hace falta..."
docker compose -f $ComposeFile build harness
if ($LASTEXITCODE -ne 0) {
    Write-Fail "docker compose build harness fallo"
    exit 1
}

docker compose -f $ComposeFile run --rm harness ./docker/scripts/verify.sh
if ($LASTEXITCODE -ne 0) {
    Write-Fail "Verificacion en contenedor fallo"
    $ExitCode = 1
} else {
    Write-Ok "Verificacion en contenedor completada"
}

Write-Host ""
Write-Host "-- 7. Resumen ------------------------------------------"
if ($ExitCode -eq 0) {
    Write-Ok "Entorno listo. Puedes empezar a trabajar."
} else {
    Write-Fail "Entorno NO esta listo. Resuelve los errores antes de avanzar."
}

exit $ExitCode
