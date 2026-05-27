# Design — init_host_checks

## Archivos

| Archivo | Rol |
|---------|-----|
| `init.sh` | Bash (Linux, macOS, Git Bash/WSL) |
| `init.ps1` | PowerShell nativo Windows |

## Flujo común

1. Detectar SO
2. Docker (version + info + compose)
3. Git (version + inside-work-tree + user.name/email)
4. GitHub CLI (version + auth status + optional expected user)
5. Archivos base del arnés
6. `docker compose -f docker/docker-compose.yml build harness` (si hace falta)
7. `docker compose -f docker/docker-compose.yml run --rm harness ./docker/scripts/verify.sh`

## Carga de .env

Si existe `.env` en la raíz, `init.sh` hace `set -a; source .env; set +a` para `GITHUB_EXPECTED_USER`.

## Alternativa descartada

**Solo init.sh en Windows:** Rechazada; el plan exige dual bash + PowerShell.
