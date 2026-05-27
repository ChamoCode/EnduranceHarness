# Requirements — init_host_checks

> Feature #3. Scripts init dual para validar el host antes de trabajar con el arnés.

## R1
CUANDO se ejecute `init.sh`, el sistema DEBE detectar el sistema operativo (linux, macos o windows-bash).

## R2
CUANDO se ejecute `init.ps1`, el sistema DEBE reportar windows-powershell con la versión de PowerShell.

## R3
El sistema DEBE verificar que Docker está instalado, el daemon responde y `docker compose` está disponible.

## R4
El sistema DEBE verificar que Git está instalado, el directorio es un repositorio git y `user.name`/`user.email` están configurados.

## R5
El sistema DEBE verificar que GitHub CLI está instalado y `gh auth status` indica sesión activa.

## R6
DONDE exista `.env` con `GITHUB_EXPECTED_USER`, el sistema DEBE verificar que coincide con `gh api user -q .login`.

## R7
El sistema DEBE verificar la existencia de los archivos base del arnés.

## R8
El sistema DEBE delegar la verificación del arnés a `docker compose run harness ./docker/scripts/verify.sh`.

## R9
El sistema NO DEBE requerir python3 instalado en el host.
