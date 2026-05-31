# R2D2-Harness

> *Cooperative agents. Spec before launch. Trust, but verify.*

Plugin dual para **Cursor** y **Claude Code** que implementa el arnés **Harness Engineering**: agentes cooperativos, flujo SDD + TDD, enrutamiento automático de modelos por complejidad y comando `r2d2 init` para agregar tracking a cualquier repo.

---

## Tabla de contenidos

1. [Instalacion del plugin](#1-instalacion-del-plugin)
2. [Inicializar un proyecto](#2-inicializar-un-proyecto)
3. [Definir el backlog](#3-definir-el-backlog)
4. [Flujos de desarrollo](#4-flujos-de-desarrollo)
   - [SDD — Spec Driven Development](#sdd--spec-driven-development)
   - [TDD + SDD — combinado](#tdd--sdd--combinado)
   - [Libre — sin flags](#libre--sin-flags)
5. [Enrutamiento de modelos por complejidad](#5-enrutamiento-de-modelos-por-complejidad)
6. [Agentes disponibles](#6-agentes-disponibles)
7. [Skills disponibles](#7-skills-disponibles)
8. [Estructura de archivos generados](#8-estructura-de-archivos-generados)
9. [Referencia r2d2 init](#9-referencia-r2d2-init)
10. [Comandos del dia a dia](#10-comandos-del-dia-a-dia)
11. [Desarrollo y validacion del plugin](#11-desarrollo-y-validacion-del-plugin)
12. [Publicar en marketplace](#12-publicar-en-marketplace)
13. [Estructura interna del plugin](#13-estructura-interna-del-plugin)

---

## 1. Instalacion del plugin

### Cursor

**Desde el marketplace:**

`Ctrl+Shift+P` → **Cursor: Open Plugin Marketplace** → busca `r2d2-harness` → Instalar

**Local (desarrollo / prueba):**

```powershell
# Windows — crea un junction al repo clonado
New-Item -ItemType Junction `
  -Path "$env:USERPROFILE\.cursor\plugins\local\r2d2-harness" `
  -Target "C:\ruta\a\R2D2-Harness"
```

```bash
# macOS / Linux — symlink
ln -s /ruta/a/R2D2-Harness ~/.cursor/plugins/local/r2d2-harness
```

Luego: `Ctrl+Shift+P` → **Reload Window** para que Cursor reconozca el plugin.

### Claude Code

```bash
# Desde el marketplace oficial
claude plugin install r2d2-harness@chamocode --scope user

# Local (desarrollo)
claude --plugin-dir /ruta/a/R2D2-Harness
```

Verificar:

```bash
claude plugin validate /ruta/a/R2D2-Harness
```

---

## 2. Inicializar un proyecto

### Modo ligero (default recomendado)

Agrega solo la estructura de tracking (`specs/`, `progress/`, archivos de config) a un repo **ya existente**, sin tocar tu código.

```powershell
# Windows
.\bin\r2d2.ps1 init -Name mi-api -Path .\mi-api

# macOS / Linux
./bin/r2d2 init --name mi-api --path ./mi-api
```

Archivos creados:

```
mi-api/
├── specs/                    ← carpetas de specs SDD (vacía al inicio)
├── progress/
│   ├── current.md            ← bitácora de la sesión activa
│   └── history.md            ← historial de sesiones cerradas
├── feature_list.json         ← backlog / mission log
├── models.config.json        ← tiers y perfiles de modelo
├── AGENTS.md                 ← contexto y reglas para los agentes
├── CLAUDE.md                 ← instrucciones de arranque para Claude Code
└── .claude/
    └── settings.json         ← hooks ligeros (sin docker)
```

> El proyecto `mi-api` puede ser un repo de Node, Python, Go, etc. El arnés solo agrega tracking; tu estructura de código no cambia.

### Modo completo (`--full`)

Scaffold completo: incluye `docker/`, `docs/`, `product/`, `tests/` e `init scripts`. Ideal para proyectos nuevos que usen el stack full con Docker.

```powershell
# Windows
.\bin\r2d2.ps1 init -Name mi-saas -Path .\mi-saas -Full -GitInit

# macOS / Linux
./bin/r2d2 init --name mi-saas --path ./mi-saas --full --git-init
```

La flag `--git-init` / `-GitInit` ejecuta `git init` en el destino.

---

## 3. Definir el backlog

Edita `feature_list.json` con la skill **feature-list** o manualmente. Cada feature tiene:

```json
{
  "id": 1,
  "name": "user_auth_api",
  "title": "API de autenticacion con JWT",
  "layer": "backend",
  "complexity": "medium",
  "sdd": true,
  "tdd": true,
  "description": "Endpoints de login y registro con JWT.",
  "acceptance": [
    "POST /auth/login retorna 200 con token para credenciales validas",
    "POST /auth/login retorna 401 para credenciales invalidas",
    "Tests pasan en CI"
  ],
  "status": "pending"
}
```

### Campos clave

| Campo | Tipo | Descripcion |
|-------|------|-------------|
| `name` | string | snake_case; define la ruta `specs/<name>/` |
| `layer` | string | `backend`, `frontend`, `fullstack`, `docker` / `infra` |
| `complexity` | string | `trivial`, `simple`, `medium`, `complex`, `very_complex` |
| `sdd` | boolean | `true` = spec obligatorio antes de codigo + puerta humana |
| `tdd` | boolean | `true` = implementer escribe tests antes de logica (Red→Green→Refactor) |
| `model_override` | object | Override de tier por rol: `{"implementer": "strong"}` |
| `status` | string | `pending` → `spec_ready` → `in_progress` → `done` / `blocked` |

### Cuando usar `tdd: true`

| Señal | Ejemplo |
|-------|---------|
| Logica pura con contratos claros | Parsers, calculadoras, transformaciones |
| API con contratos predefinidos | Endpoints con schema conocido |
| Corregir un bug con regresion | Test que reproduce el bug antes de corregirlo |
| Feature `complex` sin cobertura existente | Evita deuda tecnica desde el inicio |

No recomendado para: UI con mucho estado visual, integraciones sin mock, infra Docker pura.

---

## 4. Flujos de desarrollo

La frase de activacion es siempre la misma:

> **"Implementa la siguiente feature pendiente"**

El **leader** lee `feature_list.json`, detecta el status de la primera feature no-`done` y sigue el flujo correspondiente.

---

### SDD — Spec Driven Development

Activado con `"sdd": true` en la feature.

```
pending
  └─► [spec_author]
        ├─ specs/<name>/requirements.md
        ├─ specs/<name>/design.md
        └─ specs/<name>/tasks.md
        → status: spec_ready

spec_ready
  └─► ⏸ TÚ REVISAS EL SPEC
        → "aprobado" / pide cambios

in_progress
  └─► [implementer_*]  →  [docker_manager?]  →  [reviewer_*]
        → status: done
```

**Tu rol como humano:** revisar `specs/<name>/` y decir "aprobado". El leader no puede continuar sin esa aprobacion (Caso C).

Los specs siguen el formato **EARS** (Easy Approach to Requirements Syntax):
- `requirements.md` — requisitos numerados `R1`, `R2`… cada uno verificable
- `design.md` — archivos a modificar, firmas, alternativas descartadas
- `tasks.md` — pasos con `[ ]` que referencian `R<n>`

---

### TDD + SDD — combinado

Activado con `"sdd": true` + `"tdd": true`.

```
pending
  └─► [spec_author]
        ├─ specs/<name>/requirements.md
        ├─ specs/<name>/design.md
        ├─ specs/<name>/tasks.md
        └─ specs/<name>/tests.md   ← stubs de tests (contratos, no código)
        → status: spec_ready

spec_ready
  └─► ⏸ TÚ REVISAS EL SPEC + TESTS.MD

in_progress
  └─► [implementer — Red]    escribe tests del tests.md (deben fallar)
  └─► [implementer — Green]  implementa logica minima para que pasen
  └─► [implementer — Refactor] mejora sin romper tests
  └─► [reviewer]             verifica que tests existian antes que logica
        → status: done
```

El archivo `tests.md` que genera el `spec_author` son **stubs**, no código:

```markdown
## T1 — Login exitoso

- **Unidad bajo test:** `POST /auth/login`
- **Entrada:** `{ "email": "user@test.com", "password": "correct" }`
- **Salida esperada:** HTTP 200 con `{ "token": "<jwt>" }`
- **R1 cubierto:** sistema DEBE retornar token para credenciales validas
```

El implementer traduce cada stub a código de test real, lo hace fallar (Red), implementa la lógica (Green), y refactoriza.

---

### Libre — sin flags

`sdd: false` + `tdd: false`: el implementer trabaja directamente sin spec ni ciclo TDD. Útil para tasks triviales o prototipos.

---

### Combinaciones posibles

| `sdd` | `tdd` | Flujo |
|-------|-------|-------|
| `false` | `false` | Implementacion directa |
| `true` | `false` | SDD: spec → aprobacion → codigo |
| `true` | `true` | SDD + TDD: spec + tests.md → aprobacion → Red/Green/Refactor |
| `false` | `true` | TDD sin spec formal |

---

## 5. Enrutamiento de modelos por complejidad

Cada subagente usa el modelo apropiado automaticamente. El leader resuelve:

```
feature.complexity
  → models.config.json → profiles[complexity][role]
  → tiers[tier][platform]
  → model ID concreto
```

### Tiers por defecto

| Tier | Cursor | Claude Code |
|------|--------|-------------|
| `fast` | composer-2.5-fast | haiku |
| `standard` | claude-4.6-sonnet-medium-thinking | sonnet |
| `strong` | claude-opus-4-8-thinking-high | opus |

### Perfiles por complejidad

| complexity | spec_author | implementer | reviewer | explore |
|------------|-------------|-------------|----------|---------|
| `trivial` | fast | fast | fast | fast |
| `simple` | standard | fast | standard | fast |
| `medium` | standard | standard | standard | fast |
| `complex` | strong | standard | strong | fast |
| `very_complex` | strong | strong | strong | fast |

> `explore` siempre es `fast` — los agentes de exploración son economicos por diseno.

### Personalizar modelos

Edita `models.config.json` en tu proyecto. Para cambiar el modelo de toda una complejidad, solo cambia el tier:

```json
{
  "tiers": {
    "standard": {
      "cursor": "claude-4.6-sonnet-medium-thinking",
      "claude": "sonnet"
    }
  }
}
```

### Override por feature

Para una feature especifica que necesita mas potencia:

```json
{
  "name": "critical_migration",
  "complexity": "medium",
  "model_override": {
    "implementer": "strong",
    "reviewer": "strong"
  }
}
```

---

## 6. Agentes disponibles

| Agente | Rol | Cuando lo lanza el leader |
|--------|-----|--------------------------|
| `leader` | Orquestador — descompone y coordina, nunca implementa | Tu lo activas directamente |
| `spec_author` | Redacta specs EARS + `tests.md` si TDD | Feature en `pending` con `sdd: true` |
| `backend_implementer` | Implementa capa backend | Feature `layer: backend` |
| `frontend_implementer` | Implementa capa frontend | Feature `layer: frontend` |
| `implementer` | Implementa fullstack o capa indefinida | `layer: fullstack` o ausente |
| `docker_manager` | Gestiona Docker y compose | Tasks con infra Docker |
| `backend_reviewer` | Revisa cambios backend | Tras `backend_implementer` |
| `frontend_reviewer` | Revisa cambios frontend | Tras `frontend_implementer` |
| `reviewer` | Revision generica | Tras `implementer` o `docker_manager` |

Todos los agentes tienen `model: inherit` — el leader asigna el modelo resuelto.

---

## 7. Skills disponibles

Las skills son instrucciones especializadas que el agente lee y sigue. Se activan nombrándolas.

| Skill | Activacion | Para que sirve |
|-------|-----------|----------------|
| `feature-list` | "Usa skill feature-list para crear el backlog" | Crear y editar `feature_list.json` con complexity y tdd |
| `model-routing` | "Consulta skill model-routing" | Resolver modelo por rol y complejidad; editar `models.config.json` |
| `agent-author` | "Usa skill agent-author para crear un agente" | Crear o modificar agentes personalizados |

---

## 8. Estructura de archivos generados

Tras `r2d2 init` (modo ligero), la estructura de tracking en tu repo:

```
tu-repo/
├── specs/
│   └── <feature_name>/
│       ├── requirements.md   ← generado por spec_author
│       ├── design.md         ← generado por spec_author
│       ├── tasks.md          ← generado por spec_author
│       └── tests.md          ← generado por spec_author si tdd: true
│
├── progress/
│   ├── current.md            ← bitacora de sesion activa (se vacia al cerrar)
│   ├── history.md            ← historial acumulado
│   ├── impl_<name>.md        ← evidencia del implementer
│   └── review_<name>.md      ← resultado del reviewer
│
├── feature_list.json         ← backlog / mission log
├── models.config.json        ← configuracion de modelos
├── AGENTS.md                 ← reglas y mapa del repo para agentes
└── CLAUDE.md                 ← instrucciones de arranque (Claude Code)
```

---

## 9. Referencia `r2d2 init`

### PowerShell (Windows)

```powershell
.\bin\r2d2.ps1 init -Name <nombre> -Path <directorio> [-Force] [-GitInit] [-Full]
```

| Parametro | Descripcion |
|-----------|-------------|
| `-Name` | Identificador del proyecto (snake_case) |
| `-Path` | Directorio destino (se crea si no existe; `.` = directorio actual) |
| `-Force` | Permite escribir en directorio no vacio |
| `-GitInit` | Ejecuta `git init` en el destino |
| `-Full` | Modo completo: copia `docker/`, `docs/`, `product/`, `tests/`, `init.sh/.ps1` |

### Bash (macOS / Linux)

```bash
./bin/r2d2 init --name <nombre> --path <directorio> [--force] [--git-init] [--full]
```

### Ejemplos

```powershell
# Agregar tracking a un repo existente (modo ligero)
.\bin\r2d2.ps1 init -Name mi-api -Path .

# Nuevo repo vacío con git
.\bin\r2d2.ps1 init -Name mi-saas -Path .\mi-saas -GitInit

# Scaffold completo (con docker, docs, product)
.\bin\r2d2.ps1 init -Name mi-saas -Path .\mi-saas -Full -GitInit

# Sobreescribir carpeta existente
.\bin\r2d2.ps1 init -Name mi-api -Path .\mi-api -Force
```

---

## 10. Comandos del dia a dia

Una vez inicializado el proyecto y con el plugin instalado, el flujo típico es:

### Iniciar una feature

```
"Implementa la siguiente feature pendiente"
```

El leader:
1. Lee `feature_list.json` y detecta la primera feature en `pending`
2. Lanza `spec_author` → crea `specs/<name>/`
3. Te pide que revises el spec

### Aprobar el spec e implementar

```
"aprobado"
```

o con feedback:

```
"Ajusta R2 para incluir el caso de token expirado, luego continúa"
```

### Revisar el progreso

```
"¿Que hay en progress/current.md?"
"¿Cuál es el estado de las features?"
```

### Crear el backlog desde cero

```
"Usa skill feature-list para crear el backlog del proyecto.
Tengo una API REST de e-commerce con: catálogo, carrito, checkout y pagos."
```

### Agregar una feature al backlog

```
"Agrega al backlog una feature para notificaciones push, backend, complexity medium, sdd y tdd activados"
```

### Cerrar la sesion

```
"Cierra la sesión: mueve current.md a history y vacía current"
```

---

## 11. Desarrollo y validacion del plugin

```powershell
# Validar estructura del plugin
powershell -File .\scripts\validate-plugin.ps1

# Validar plugin para Claude Code
claude plugin validate .

# Regenerar example minimal (smoke test)
.\bin\r2d2.ps1 init -Name minimal -Path .\examples\minimal -Force
```

---

## 12. Publicar en marketplace

### Cursor

1. Asegura que `.cursor-plugin/plugin.json` está completo
2. Sube el repo a GitHub
3. Envía a [cursor.com/marketplace/publish](https://cursor.com/marketplace/publish)

### Claude Code

```bash
# Marketplace personal / empresa
claude plugin marketplace add tu-usuario/R2D2-Harness

# Validacion previa
claude plugin validate .
```

Referencia completa: [PLUGIN.md](PLUGIN.md)

---

## 13. Estructura interna del plugin

```
R2D2-Harness/
├── .cursor-plugin/
│   └── plugin.json               ← manifest Cursor
├── .claude-plugin/
│   ├── plugin.json               ← manifest Claude Code
│   └── marketplace.json          ← entrada de marketplace privado
│
├── agents/                       ← 9 subagentes (model: inherit)
│   ├── leader.md
│   ├── spec_author.md
│   ├── backend_implementer.md
│   ├── frontend_implementer.md
│   ├── implementer.md
│   ├── docker_manager.md
│   ├── backend_reviewer.md
│   ├── frontend_reviewer.md
│   └── reviewer.md
│
├── skills/
│   ├── feature-list/             ← backlog SDD/TDD
│   ├── model-routing/            ← resolucion de modelos
│   └── agent-author/             ← crear/modificar agentes
│
├── rules/
│   ├── leader-role.mdc           ← reglas del leader para Cursor
│   └── sdd-protocol.mdc          ← protocolo SDD para Cursor
│
├── hooks/
│   ├── hooks.json.template       ← hooks para modo --full (con docker)
│   └── hooks-lite.json.template  ← hooks para modo ligero
│
├── bin/
│   ├── r2d2                      ← CLI Bash
│   ├── r2d2.ps1                  ← CLI PowerShell
│   ├── r2d2-init.sh              ← logica de scaffold Bash
│   └── r2d2-init.ps1             ← logica de scaffold PowerShell
│
├── templates/
│   ├── lite/                     ← templates para r2d2 init (default)
│   │   ├── AGENTS.md.template
│   │   ├── CLAUDE.md.template
│   │   └── feature_list.json.template
│   └── project/                  ← templates para r2d2 init --full
│       ├── docker/
│       ├── docs/
│       ├── product/
│       ├── tests/
│       └── ...
│
├── scripts/
│   └── validate-plugin.ps1       ← validacion estructural del plugin
│
├── examples/
│   └── minimal/                  ← proyecto de ejemplo / smoke test
│
├── PLUGIN.md                     ← metadata y changelog del plugin
└── README.md                     ← este archivo
```

---

## Origen

Plugin derivado del arnés Harness Engineering.
Repo: [github.com/ChamoCode/R2D2-Harness](https://github.com/ChamoCode/R2D2-Harness)
