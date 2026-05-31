# CHECKPOINTS — Evaluación del estado final

> Checkpoints objetivos para juez humano o IA.

## C1 — El arnés está completo

- [ ] Existen: `AGENTS.md`, `init.sh`, `init.ps1`, `feature_list.json`, `progress/current.md`
- [ ] Existen: `docs/architecture.md`, `docs/conventions.md`, `docs/verification.md`, `docs/docker.md`
- [ ] Existe infra: `docker/Dockerfile.harness`, `docker/docker-compose.yml`, `docker/scripts/verify.sh`
- [ ] `./init.sh` o `./init.ps1` termina con exit code 0

## C2 — El estado es coherente

- [ ] Como mucho una feature en `in_progress` en `feature_list.json`
- [ ] Toda feature `done` tiene evidencia en `progress/history.md` o informes `progress/*`
- [ ] `progress/current.md` vacío o describe solo la sesión activa

## C3 — Infra Docker sana

- [ ] `docker compose -f docker/docker-compose.yml build harness` exitoso
- [ ] `docker/scripts/verify.sh` pasa dentro del contenedor
- [ ] Existen `product/`, `tests/`, `docker/Dockerfile.product`
- [ ] `./docker/scripts/product-build.sh` y `product-test.sh` ejecutan (WARN si tests vacios en plantilla)
- [ ] No hay `.env` trackeado en git

## C4 — Host configurado

- [ ] Docker daemon activo
- [ ] Git con `user.name` y `user.email`
- [ ] `gh auth status` con sesión activa

## C5 — Cierre de sesión

- [ ] Sin archivos temporales sospechosos fuera de `.gitignore`
- [ ] Entrada en `progress/history.md` por la última sesión
- [ ] Última feature en estado correcto en `feature_list.json`

## C6 — Spec Driven Development

- [ ] Toda feature `"sdd": true` en `spec_ready`/`in_progress`/`done` tiene `specs/<name>/` completo
- [ ] `requirements.md` en EARS estricto
- [ ] Feature `done`: todas las tasks `[x]` en `tasks.md`
- [ ] Cada `R<n>` cubierto por verify.sh, smoke test o test documentado en informe

---

El reviewer recorre C1–C6 y rechaza si queda algún `[ ]` sin justificación.
