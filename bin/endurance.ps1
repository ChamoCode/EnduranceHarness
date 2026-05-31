# endurance.ps1 — CLI for Endurance Harness Engineering plugin
param(
    [Parameter(Position = 0)]
    [string]$Command,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Rest
)

$BinDir = $PSScriptRoot
switch ($Command) {
    "init" {
        & (Join-Path $BinDir "endurance-init.ps1") @Rest
    }
    default {
        Write-Host "Usage: endurance init -Name <name> -Path <directory> [-Force] [-GitInit] [-Full]"
        Write-Host ""
        Write-Host "  -Full   Full mode: copies docker/, docs/, product/, tests/, init scripts."
        Write-Host "          Default creates only specs/, progress/ and tracking files."
        exit 1
    }
}
