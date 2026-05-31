# r2d2.ps1 — CLI del plugin R2D2-Harness
param(
    [Parameter(Position = 0)]
    [string]$Command,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Rest
)

$BinDir = $PSScriptRoot
switch ($Command) {
    "init" {
        & (Join-Path $BinDir "r2d2-init.ps1") @Rest
    }
    default {
        Write-Host "Uso: r2d2 init -Name <nombre> -Path <directorio> [-Force] [-GitInit] [-Full]"
        Write-Host ""
        Write-Host "  -Full   Modo completo: copia docker/, docs/, product/, tests/, init scripts."
        Write-Host "          Por defecto solo crea specs/, progress/ y archivos de tracking."
        exit 1
    }
}
