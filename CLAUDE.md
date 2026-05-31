# Instrucciones para Claude — Repositorio del plugin

> En este repo desarrollas el **plugin** endurance-harness-engineering, no un producto SDD.
> Para trabajar en un producto, usa `endurance init` y abre el proyecto generado.

## Rol en este repo

- Cambios en `agents/`, `skills/`, `rules/`, `templates/`, `bin/` → desarrollo del plugin
- No hay `feature_list.json` ni `product/` en la raiz del plugin
- Prueba el scaffold en `examples/minimal/` o genera uno nuevo con `endurance init`

## Validacion

```powershell
.\bin\endurance-init.ps1 -Name test -Path .\examples\test -Force
cd examples\test
.\init.ps1
```
