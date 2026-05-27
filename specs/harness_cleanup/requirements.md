# Requirements — harness_cleanup

> Feature #1. Eliminar el producto notes-cli embebido y preparar el repo como plantilla pura de arnés.

## R1
El sistema DEBE eliminar por completo los directorios `src/` y `tests/`.

## R2
El sistema DEBE eliminar el directorio `specs/cli_recent/` y cualquier otro spec del producto CLI.

## R3
El sistema DEBE eliminar los archivos `progress/impl_*.md`, `progress/review_*.md` y `progress/explore_*.md`.

## R4
CUANDO se complete la limpieza, el sistema DEBE dejar `progress/current.md` con solo la plantilla vacía.

## R5
CUANDO se complete la limpieza, el sistema DEBE añadir una entrada al final de `progress/history.md` documentando el cierre del proyecto notes-cli y el inicio de la plantilla harness.

## R6
El sistema DEBE actualizar `.gitignore` para incluir `.env` y eliminar entradas específicas del notes-cli (`.notes.json`, `.notes_*.json`).

## R7
El sistema NO DEBE eliminar entradas anteriores de `progress/history.md`.
