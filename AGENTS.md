# AGENTS.md — Mapa de navegacion para agentes de IA

> Punto de entrada del arnes. Lee solo lo que necesites (divulgacion progresiva).

---

## 1. Antes de empezar (obligatorio)

1. Ejecuta `./init.sh` (o `./init.ps1` en Windows PowerShell). Si falla, **para**
   y resuelve el entorno.
2. Lee `progress/current.md` para el estado de la sesion.
3. Lee `feature_list.json`. Features con `"sdd": true` siguen SDD — ver `docs/specs.md`.
4. Lee `docs/specs.md` antes de redactar o implementar un spec.

**Nuevo proyecto:** clona esta plantilla, usa `skills/feature-list/SKILL.md` para
el backlog y arranca SDD. Ver [`README.md`](README.md).

## 2. Mapa del repositorio

| Archivo / carpeta | Que contiene | Cuando leerlo |
|-------------------|--------------|---------------|
| `feature_list.json` | Backlog con estados y `layer` | Siempre |
| `skills/` | Skills feature-list, agent-author | Crear backlog o agentes |
| `product/backend/` | Codigo backend | layer backend |
| `product/frontend/` | Codigo frontend | layer frontend |
| `tests/backend/` | Tests backend | Verificar backend |
| `tests/frontend/` | Tests frontend | Verificar frontend |
| `progress/current.md` | Sesion activa | Siempre |
| `specs/<feature>/` | requirements + design + tasks | Antes de implementar |
| `docs/architecture.md` | Capas arnes + producto | Antes de implementar |
| `docs/conventions.md` | Convenciones product/ y Docker | Antes de escribir |
| `docs/docker.md` | Build, test, up, down del producto | Al tocar Docker |
| `docs/specs.md` | Proceso SDD | Specs e implementacion |
| `docs/verification.md` | Como verificar | Antes de cerrar feature |
| `docker/` | Dockerfiles, compose, scripts | Infra y producto |
| `init.sh` / `init.ps1` | Checks del host | Inicio y cierre |
| `.claude/agents/` | Ver tabla abajo | Orquestacion |

### Agentes en `.claude/agents/`

| Agente | Rol |
|--------|-----|
| `leader` | Orquesta; no implementa |
| `spec_author` | Specs EARS |
| `backend_implementer` | Implementa `product/backend/` |
| `frontend_implementer` | Implementa `product/frontend/` |
| `implementer` | Fullstack generico |
| `docker_manager` | Docker y compose |
| `backend_reviewer` | Revisa backend |
| `frontend_reviewer` | Revisa frontend |
| `reviewer` | Revisa fullstack/infra |

## 3. Reglas duras

- **Una feature a la vez.** Maximo una en `in_progress`.
- **No declares `done` sin verify verde.** `./init.sh` o `./init.ps1` al cierre.
- **No saltes SDD** ni la puerta humana en `spec_ready`.
- **Producto in-repo:** backend/frontend segun `layer`; ejecucion en contenedor.

## 4. Flujo SDD

```
pending → [spec_author] → spec_ready → ⏸ HUMANO → in_progress
  → [implementer_* / docker_manager] → [reviewer_*] → done
```

## 5. Cierre de sesion

1. `./init.sh` o `./init.ps1` — verde.
2. Feature completada → `status: "done"` en `feature_list.json`.
3. Resumen de `progress/current.md` → `progress/history.md`.
4. Vacia `progress/current.md` (plantilla).

## 6. Si te bloqueas

- Relee `docs/` o `skills/` relevante.
- Documenta el bloqueo en `progress/current.md` y para.
