# Ejemplos — feature_list.json

## Backend — API health

```json
{
  "id": 1,
  "name": "health_api",
  "title": "Endpoint health",
  "layer": "backend",
  "description": "GET /health devuelve status ok para probes.",
  "acceptance": [
    "Existe product/backend/routes/health.py",
    "GET /health responde 200 con body {\"status\":\"ok\"}",
    "tests/backend/test_health.py cubre respuesta 200",
    "./docker/scripts/product-test.sh pasa"
  ],
  "sdd": true,
  "status": "pending"
}
```

## Frontend — pantalla login

```json
{
  "id": 2,
  "name": "login_page",
  "title": "Pantalla de login",
  "layer": "frontend",
  "description": "Formulario email/password que llama a la API de auth.",
  "acceptance": [
    "Existe product/frontend/pages/Login.tsx (o equivalente)",
    "Muestra errores de API en UI",
    "tests/frontend/test_login.test.tsx cubre submit exitoso",
    "./docker/scripts/product-test.sh pasa"
  ],
  "sdd": true,
  "status": "pending"
}
```

## Fullstack — sin layer (usa implementer genérico)

```json
{
  "id": 3,
  "name": "shared_config",
  "title": "Config compartida",
  "layer": "fullstack",
  "description": "Variables de entorno compartidas backend y frontend.",
  "acceptance": [
    "Existe product/config.py y product/frontend/config.ts",
    "Documentado en docs/architecture.md",
    "./docker/scripts/product-test.sh pasa"
  ],
  "sdd": true,
  "status": "pending"
}
```

## Infra Docker

```json
{
  "id": 4,
  "name": "add_postgres",
  "title": "Servicio Postgres en compose",
  "layer": "docker",
  "description": "Añadir postgres al perfil product en docker-compose.",
  "acceptance": [
    "Servicio db en docker/docker-compose.yml perfil product",
    "Smoke test documentado en progress/docker_add_postgres.md",
    "./init.sh verde"
  ],
  "sdd": true,
  "status": "pending"
}
```
