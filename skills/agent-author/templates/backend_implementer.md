# Diff — backend_implementer

Partir de implementer-base.md con:

| Placeholder | Valor |
|-------------|-------|
| name | backend_implementer |
| Title | Implementador Backend |
| scope | product/backend/ |
| test_dir | tests/backend/ |

## Reglas adicionales

- No editar product/frontend/ ni tests/frontend/
- API/contracts: documentar en design.md del spec; no cambiar contrato sin spec update
- Verificar endpoints con tests de integracion en tests/backend/ cuando aplique
- Preferir product/backend/ para modulos: routes, services, models, db

## Verificacion

```bash
./docker/scripts/product-test.sh
# o: python3 -m unittest discover -s tests/backend -v (dentro de contenedor)
```
