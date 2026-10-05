# Changelog

Todos los cambios relevantes de este proyecto se documentan en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/)
y este proyecto sigue [Semantic Versioning](https://semver.org/lang/es/).

## [1.0.0] - 2026-10-05

### Añadido

- `docker-compose.yml` con PostgreSQL 16, Eureka, gateway, los cuatro servicios de negocio y el frontend
- Healthchecks y arranque ordenado con `depends_on: condition: service_healthy`
- `init-db.sql` que crea las bases de datos `transacciones`, `clientes` y `auth`
- Scripts de seed de libros y clientes autenticados contra el gateway
- `.env.example` documentado con base de datos, Eureka, `JWT_SECRET` y credenciales del ADMIN inicial
- Capturas del panel web en `docs/screenshots/`
