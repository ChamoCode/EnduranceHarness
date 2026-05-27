# Requirements — docker_manager_agent

> Feature #4. Subagente especializado en infraestructura Docker del arnés.

## R1
El sistema DEBE definir `.claude/agents/docker_manager.md` con responsabilidades, protocolo y límites.

## R2
CUANDO una feature incluya tasks de Docker en `tasks.md`, el leader DEBE poder lanzar el subagente `docker_manager`.

## R3
El sistema DEBE actualizar `.claude/agents/leader.md` con cuándo lanzar `docker_manager`.

## R4
El sistema DEBE actualizar `CLAUDE.md` para incluir `docker_manager` en subagentes lanzables.

## R5
El sistema DEBE actualizar `.claude/settings.json` para usar verificación Docker en hooks PostToolUse y Stop.

## R6
El docker_manager NO DEBE marcar features como `done` ni redactar specs.
