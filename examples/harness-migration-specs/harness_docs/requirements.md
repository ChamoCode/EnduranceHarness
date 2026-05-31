# Requirements — harness_docs

> Feature #5. Documentación alineada al arnés dockerizado sin producto embebido.

## R1
El README.md DEBE describir solo la plantilla Harness Engineering dockerizada y su estructura.

## R2
El README.md NO DEBE incluir instrucciones de uso del notes-cli ni referencias a src/tests del producto.

## R3
El sistema DEBE reescribir docs/architecture.md, docs/conventions.md y docs/verification.md para el arnés.

## R4
El sistema DEBE crear docs/docker.md con convenciones de montaje de producto externo.

## R5
El sistema DEBE actualizar AGENTS.md con mapa docker/, init dual y agente docker_manager.

## R6
El sistema DEBE actualizar CHECKPOINTS.md con criterios Docker, gh auth y verify en contenedor.

## R7
El reviewer DEBE aceptar trazabilidad R<n> via verify.sh o smoke tests para features de infraestructura.
