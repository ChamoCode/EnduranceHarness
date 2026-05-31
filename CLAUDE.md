# Instrucciones para Claude — Repositorio del plugin

> En este repo desarrollas el **plugin** r2d2-harness, no un producto SDD.
> Para trabajar en un producto, usa `r2d2 init` y abre el proyecto generado.

## Rol en este repo

- Cambios en `agents/`, `skills/`, `rules/`, `templates/`, `bin/` → desarrollo del plugin
- No hay `feature_list.json` ni `product/` en la raiz del plugin
- Prueba el scaffold en `examples/minimal/` o genera uno nuevo con `r2d2 init`

## Validacion

```powershell
.\bin\r2d2-init.ps1 -Name test -Path .\examples\test -Force
cd examples\test
.\init.ps1
```
