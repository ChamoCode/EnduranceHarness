# AGENTS.md — Mapa de navegacion para agentes (minimal)

> Punto de entrada del arnes Endurance Harness Engineering. Lee solo lo que necesites.
> *Cooperative agents. Spec before launch. Trust, but verify.*

Proyecto scaffoldado con el plugin **endurance-harness-engineering**. El **leader** coordina especialistas;
cada feature es una mision con briefing (spec), go/no-go humano, y payload en `product/`.

---

## 1. Antes de empezar (obligatorio)

1. **Pre-flight:** ejecuta `./init.sh` (o `./init.ps1` en Windows PowerShell). Si falla, **para**.
2. Lee `progress/current.md` para el estado de la mision activa.
3. Lee `feature_list.json` (mission log). Features con `"sdd": true` siguen SDD — ver `docs/specs.md`.
4. Lee `models.config.json` para tiers y perfiles de modelo por complejidad.
5. Lee `docs/specs.md` antes de redactar o implementar un spec.

**Plugin:** instala `endurance-harness-engineering` en Cursor (Plugin Marketplace) o Claude Code (`claude plugin install`).

## 2. Mapa del repositorio

| Archivo / carpeta | Que contiene | Cuando leerlo |
|-------------------|--------------|---------------|
| `feature_list.json` | Mission log con `layer` y `complexity` | Siempre |
| `models.config.json` | Tiers y perfiles de modelo por complejidad | Al orquestar subagentes |
| `product/backend/` | Codigo backend (payload) | layer backend |
| `product/frontend/` | Codigo frontend (payload) | layer frontend |
| `tests/backend/` | Tests backend | Verificar backend |
| `tests/frontend/` | Tests frontend | Verificar frontend |
| `progress/current.md` | Bitacora de la mision activa | Siempre |
| `specs/<feature>/` | Briefing SDD | Antes de implementar |
| `docs/` | Arquitectura, SDD, Docker, verificacion | Segun tarea |
| `docker/` | Dockerfiles, compose, scripts | Infra y producto |
| `init.sh` / `init.ps1` | Pre-flight checks del host | Inicio y cierre |
| `agents/` (plugin) | Astromech crew / especialistas | Orquestacion |

### Agentes (plugin endurance-harness-engineering)

| Agente | Rol |
|--------|-----|
| `leader` | Orquesta; no implementa |
| `spec_author` | Specs EARS |
| `backend_implementer` / `frontend_implementer` / `implementer` | Payload por capa |
| `docker_manager` | Docker y compose |
| `backend_reviewer` / `frontend_reviewer` / `reviewer` | Control de calidad |

## 3. Reglas duras

- **Una feature a la vez.** Maximo una en `in_progress`.
- **No declares `done` sin verify verde.**
- **No saltes SDD** ni el **go/no-go humano** en `spec_ready`.
- **Modelos por complejidad:** el leader resuelve modelo desde `models.config.json` + `feature.complexity`.

## 4. Flujo SDD

```
pending → [spec_author] → spec_ready → HUMANO → in_progress
  → [implementer_* / docker_manager] → [reviewer_*] → done
```

## 5. Cierre de sesion

1. Pre-flight final: `./init.sh` o `./init.ps1` — verde.
2. Feature completada → `status: "done"` en `feature_list.json`.
3. Resumen de `progress/current.md` → `progress/history.md`.
4. Vacia `progress/current.md` (plantilla).

## Glosario

| Termino | En el repo |
|---------|------------|
| Flight plan | `feature_list.json` |
| Briefing | `specs/<feature>/` |
| Go/no-go | Aprobacion humana en `spec_ready` |
| Payload | `product/` + `tests/` |
| Pre-flight | `init.sh`, `init.ps1`, `verify.sh` |
