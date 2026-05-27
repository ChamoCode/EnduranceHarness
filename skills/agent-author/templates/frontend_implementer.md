# Diff — frontend_implementer

Partir de implementer-base.md con:

| Placeholder | Valor |
|-------------|-------|
| name | frontend_implementer |
| Title | Implementador Frontend |
| scope | product/frontend/ |
| test_dir | tests/frontend/ |

## Reglas adicionales

- No editar product/backend/ ni tests/backend/
- Consumir API via cliente definido en spec; no hardcodear URLs sin config
- Tests: component/snapshot/unit en tests/frontend/
- Accesibilidad y estados de error segun acceptance del spec

## Verificacion

```bash
./docker/scripts/product-test.sh
```

Adaptar Dockerfile.product cuando el stack frontend no sea Python (via docker_manager + SDD).
