# Arquitectura — Capas del arnés y del producto

> Define que significa "buen trabajo" en esta plantilla. El reviewer evalua
> cambios contra este documento.

## Principios

1. **El repositorio ES el sistema.** Estado, specs y progreso viven en disco,
   no en el chat del agente.

2. **Plantilla clonable.** Este repo es el arnes vacio; al clonarlo defines
   un repo de producto con el mismo esqueleto y un `feature_list.json` propio.

3. **Producto in-repo.** El codigo vive en `product/` y los tests en `tests/`.
   Crece feature a feature via SDD.

4. **Verificacion en contenedor.** El arnes se valida con `harness` +
   `verify.sh`. El producto se construye, testea, arranca y detiene con
   perfil compose `product` (`app`, `test`).

5. **Una feature a la vez.** Maximo una en `in_progress` en `feature_list.json`.

6. **SDD con puerta humana.** Spec aprobado antes de implementacion.

## Capas

```
┌─────────────────────────────────────────────────┐
│  Orquestacion (.claude/agents/, CLAUDE.md)      │
├─────────────────────────────────────────────────┤
│  Proceso (feature_list, specs/, docs/specs.md)  │
├─────────────────────────────────────────────────┤
│  Estado (progress/, CHECKPOINTS.md)             │
├─────────────────────────────────────────────────┤
│  Infra (docker/, init.sh, init.ps1)             │
├─────────────────────────────────────────────────┤
│  Producto (product/, tests/) — crece via SDD     │
└─────────────────────────────────────────────────┘
         │
         ▼  docker compose --profile product
┌─────────────────────────────────────────────────┐
│  Imagen producto (Dockerfile.product)           │
│  Servicios app (run) + test (verify)            │
└─────────────────────────────────────────────────┘
```

## Agentes y responsabilidades

| Agente | Puede | No puede |
|--------|-------|----------|
| leader | Orquestar, editar progress/feature status (no done) | Implementar, marcar done |
| spec_author | Escribir specs | Escribir codigo |
| implementer | Codigo en `product/`, tests en `tests/` | Auto-aprobar, marcar done |
| docker_manager | `Dockerfile.product`, compose app/test, scripts | Specs, marcar done |
| reviewer | Aprobar/rechazar | Editar codigo |

## Que NO hacer

- No desarrollar el producto fuera de `product/` y `tests/` sin documentarlo en el spec.
- No verificar el arnes con herramientas no documentadas en `docs/verification.md`.
- No saltar `./init.sh` / `./init.ps1` al inicio o cierre de sesion.
- No ejecutar tests del producto solo en el host si el spec exige contenedor.
