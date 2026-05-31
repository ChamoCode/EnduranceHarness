---
name: model-routing
description: >-
  Resuelve modelos por rol y complejidad de feature usando models.config.json.
  Usar al orquestar subagentes, editar tiers/perfiles, o interpretar complexity
  en feature_list.json para optimizar tokens.
---

# Model Routing — Perfiles por complejidad

## Cuando usar

- El leader va a lanzar un subagente y necesita el `model` correcto
- Editar `models.config.json` (tiers o profiles)
- Entender que modelo usa cada rol segun `complexity` de la feature
- Override puntual con `model_override` en una feature

## Resolucion (leader)

1. Lee la feature activa en `feature_list.json` → campo `complexity` (default `medium` si ausente).
2. Lee `models.config.json`:
   - `profiles[complexity][role]` → nombre de tier (`fast`, `standard`, `strong`)
   - `tiers[tier][platform]` → ID de modelo concreto
3. Plataforma: si `platform` es `auto`, usa `cursor` en Cursor IDE y `claude` en Claude Code.
4. Si la feature tiene `model_override.<role>`, usa ese tier o ID directamente.
5. Pasa `model: "<resolved_id>"` al invocar Task/Agent.

## Roles mapeados

| subagent_type | Rol en profiles |
|---------------|-----------------|
| `spec_author` | spec_author |
| `backend_implementer`, `frontend_implementer`, `implementer`, `docker_manager` | implementer |
| `backend_reviewer`, `frontend_reviewer`, `reviewer` | reviewer |
| Explore / general-purpose | explore |

## Heuristica de complexity (feature-list)

| complexity | Senales |
|------------|---------|
| `trivial` | 1 archivo, sin logica nueva, patron existente |
| `simple` | 1-2 archivos, una capa, CRUD directo |
| `medium` | Multi-archivo, una capa, integracion estandar |
| `complex` | Cross-layer, refactor, infra Docker, muchos acceptance |
| `very_complex` | Migracion, arquitectura nueva, requiere explorers previos |

Al crear features, propone `complexity` y muestra el perfil resultante; el humano confirma.

## Editar tiers

Ajusta IDs en `models.config.json` → `tiers` segun tu plan:

```json
{
  "tiers": {
    "fast": { "cursor": "composer-2.5-fast", "claude": "haiku" },
    "standard": { "cursor": "claude-4.6-sonnet-medium-thinking", "claude": "sonnet" },
    "strong": { "cursor": "claude-opus-4-8-thinking-high", "claude": "opus" }
  }
}
```

Los `profiles` referencian tiers, no IDs crudos — cambia tiers una vez y aplica a todas las complejidades.

## Override por feature

```json
{
  "name": "critical_auth",
  "complexity": "medium",
  "model_override": {
    "implementer": "strong",
    "reviewer": "strong"
  }
}
```

## Escalado con complexity

| complexity | Explorers previos | Perfil tipico |
|------------|-------------------|---------------|
| trivial, simple | No | fast/standard economico |
| medium | Opcional | standard balanceado |
| complex, very_complex | Si (tier fast) | strong en spec/review |

Ver `agents/leader.md` para integracion con flujo SDD.
