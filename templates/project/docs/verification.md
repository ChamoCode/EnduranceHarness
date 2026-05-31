# Verificacion — Como demostrar que el trabajo funciona

> Regla de oro: **el agente no dice "funciona", lo demuestra**.

## Nivel 1 — Host (obligatorio al inicio y cierre)

```bash
./init.sh          # bash
./init.ps1         # PowerShell
```

Comprueba: SO, Docker daemon, Git, `gh auth status`, archivos base del arnes.

## Nivel 2 — Arnés en contenedor (obligatorio)

```bash
docker compose -f docker/docker-compose.yml run --rm harness ./docker/scripts/verify.sh
```

Incluye: archivos base, `feature_list.json`, specs SDD, infra `docker/`.

`init.sh` / `init.ps1` ejecutan este nivel automaticamente.

## Nivel 3 — Producto en contenedor (obligatorio para features de producto)

```bash
./docker/scripts/product-build.sh
./docker/scripts/product-test.sh
```

Para features que anaden comportamiento ejecutable:

```bash
./docker/scripts/product-up.sh
# smoke manual o test de integracion documentado
./docker/scripts/product-down.sh
```

## Trazabilidad requirements ↔ verificacion

| Tipo de feature | Evidencia |
|-----------------|-----------|
| Infra / arnes | `R<n>` → check en `verify.sh` o smoke documentado |
| Producto | `R<n>` → test en `tests/` ejecutado via `product-test.sh` |

Documentar en `progress/impl_<name>.md` o `progress/docker_<name>.md`:

```markdown
## Trazabilidad
- R1 → test_foo en tests/test_bar.py (product-test.sh)
- R2 → product-up.sh + curl localhost:8080
```

## Tests opcionales del arnes

Si existe `tests-harness/`, `verify.sh` ejecuta `unittest` ahi.

## Que NO cuenta como verificacion

- Afirmaciones en chat sin salida de comando
- Marcar `done` sin `./init.sh` verde
- Tests del producto solo en host cuando el spec exige contenedor
