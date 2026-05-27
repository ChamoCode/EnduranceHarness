# AGENTS.md — Mapa de navegación para agentes (R2D2-Harness)

> Punto de entrada del arnés R2D2-Harness. Lee solo lo que necesites (divulgación progresiva).
> *Cooperative agents. Spec before launch. Trust, but verify.*

R2D2-Harness es un arnés SDD: el **leader** coordina especialistas; cada feature es una
misión con briefing (spec), go/no-go humano, y payload en `product/`.

---

## 1. Antes de empezar (obligatorio)

1. **Pre-flight:** ejecuta `./init.sh` (o `./init.ps1` en Windows PowerShell). Si falla, **para**
   y resuelve el entorno.
2. Lee `progress/current.md` para el estado de la misión activa.
3. Lee `feature_list.json` (mission log). Features con `"sdd": true` siguen SDD — ver `docs/specs.md`.
4. Lee `docs/specs.md` antes de redactar o implementar un spec.

**Nueva misión:** clona esta plantilla desde [github.com/ChamoCode/R2D2-Harness](https://github.com/ChamoCode/R2D2-Harness),
usa `skills/feature-list/SKILL.md` para el backlog y arranca SDD. Ver [`README.md`](README.md).

## 2. Mapa del repositorio

| Archivo / carpeta | Qué contiene | Cuándo leerlo |
|-------------------|--------------|---------------|
| `feature_list.json` | Mission log / backlog con estados y `layer` | Siempre |
| `skills/` | Skills feature-list, agent-author | Crear backlog o agentes |
| `product/backend/` | Código backend (payload) | layer backend |
| `product/frontend/` | Código frontend (payload) | layer frontend |
| `tests/backend/` | Tests backend | Verificar backend |
| `tests/frontend/` | Tests frontend | Verificar frontend |
| `progress/current.md` | Bitácora de la misión activa | Siempre |
| `specs/<feature>/` | Briefing SDD (requirements + design + tasks) | Antes de implementar |
| `docs/architecture.md` | Capas arnés + producto | Antes de implementar |
| `docs/conventions.md` | Convenciones product/ y Docker | Antes de escribir |
| `docs/docker.md` | Build, test, up, down del producto | Al tocar Docker |
| `docs/specs.md` | Proceso SDD | Specs e implementación |
| `docs/verification.md` | Cómo verificar | Antes de cerrar feature |
| `docker/` | Dockerfiles, compose, scripts | Infra y producto |
| `init.sh` / `init.ps1` | Pre-flight checks del host | Inicio y cierre |
| `docker/scripts/verify.sh` | Validación del arnés | Cierre y CI |
| `.claude/agents/` | Astromech crew / especialistas (ver tabla abajo) | Orquestación |

### Agentes en `.claude/agents/`

| Agente | Rol | En misión |
|--------|-----|-----------|
| `leader` | Orquesta; no implementa | Flight control |
| `spec_author` | Specs EARS | Redacta el briefing |
| `backend_implementer` | Implementa `product/backend/` | Especialista payload backend |
| `frontend_implementer` | Implementa `product/frontend/` | Especialista payload frontend |
| `implementer` | Fullstack genérico | Especialista payload fullstack |
| `docker_manager` | Docker y compose | Infra / vehículo de despliegue |
| `backend_reviewer` | Revisa backend | Control de calidad pre-`done` |
| `frontend_reviewer` | Revisa frontend | Control de calidad pre-`done` |
| `reviewer` | Revisa fullstack/infra | Control de calidad pre-`done` |

## 3. Reglas duras (protocolo de misión)

- **Una feature a la vez.** Máximo una en `in_progress`.
- **No declares `done` sin verify verde.** `./init.sh` o `./init.ps1` al cierre.
- **No saltes SDD** ni el **go/no-go humano** en `spec_ready`.
- **Producto in-repo:** backend/frontend según `layer`; ejecución en contenedor.

## 4. Flujo SDD

Ciclo de una misión (feature):

```
pending → [spec_author] → spec_ready → ⏸ HUMANO → in_progress
  → [implementer_* / docker_manager] → [reviewer_*] → done
```

## 5. Cierre de sesión (fin de misión)

1. **Pre-flight final:** `./init.sh` o `./init.ps1` — verde.
2. Feature completada → `status: "done"` en `feature_list.json`.
3. Resumen de `progress/current.md` → `progress/history.md`.
4. Vacía `progress/current.md` (plantilla).

## 6. Si te bloqueas

- Relee `docs/` o `skills/` relevante.
- Documenta el bloqueo en `progress/current.md` y para.

## Glosario R2D2-Harness (vocabulario; paths sin cambiar)

| Término | En el repo |
|---------|------------|
| Flight plan / mission log | `feature_list.json` |
| Briefing | `specs/<feature>/` |
| Go/no-go | Aprobación humana en `spec_ready` |
| Payload | `product/` + `tests/` |
| Pre-flight | `init.sh`, `init.ps1`, `verify.sh` |
| Flight control | Agente `leader` |
| Astromech crew | Subagentes en `.claude/agents/` |
