# Biblioteca Deploy

Despliegue de la plataforma de gestión de biblioteca con Docker Compose. Levanta el sistema completo con un solo comando: base de datos PostgreSQL, los cinco microservicios Spring Cloud y el frontend.

## Qué levanta

| Servicio | Contenedor | Puerto |
|---|---|---|
| PostgreSQL 16 | `biblioteca-postgres` | 5432 |
| discovery-service (Eureka) | `discovery-service` | 8761 |
| gateway-service | `gateway-service` | 8080 |
| catalog-service | `catalog-service` | 8081 |
| transactions-service | `transactions-service` | 8082 |
| customer-service | `customer-service` | 8083 |
| biblioteca-frontend | `biblioteca-frontend` | 3000 |

Los microservicios esperan a que PostgreSQL y Eureka estén sanos antes de arrancar (healthchecks con `pg_isready` y `wget`). El frontend sirve el build de producción con nginx y proxifica `/api` hacia el gateway.

## Requisitos

- Docker + Docker Compose
- Los repositorios de los microservicios en carpetas hermanas de esta (como en el workspace original):

```
biblioteca-deploy/
├── docker-compose.yml
└── ...
discovery-service/
catalog-service/
transactions-service/
customer-service/
gateway-service/
biblioteca-frontend/
```

## Cómo usarlo

1. Copiar el archivo de ejemplo y rellenar las credenciales:

```powershell
Copy-Item .env.example .env
```

2. Levantar el stack:

```powershell
docker compose up -d
```

3. Esperar a que los servicios estén sanos y comprobar Eureka en `http://localhost:8761` (deben verse los 5 microservicios registrados).

4. Cargar datos iniciales con los scripts:

```powershell
.\scripts-libros.ps1     # 3 libros de ejemplo
.\scripts-clientes.ps1   # 3 clientes de ejemplo
```

5. Abrir el panel en `http://localhost:3000` o la API en el gateway `http://localhost:8080`.

## Variables de entorno

El archivo `.env` (no versionado) define las credenciales de PostgreSQL y las URLs de conexión. Ver `.env.example`:

- `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB` — superusuario de la base
- `DB_USER`, `DB_PASSWORD` — credenciales que usan los microservicios
- `DB_URL_CATALOG`, `DB_URL_TRANSACTIONS`, `DB_URL_CUSTOMER` — URL JDBC de cada servicio
- `EUREKA_URL` — URL interna del servidor Eureka

## Estructura

- `docker-compose.yml` — definición de los 7 servicios
- `init-db.sql` — crea las bases de datos `transacciones` y `clientes` (la de catálogo la crea PostgreSQL con `POSTGRES_DB`)
- `scripts-libros.ps1` / `scripts-clientes.ps1` — seed de datos de ejemplo vía el gateway
- `.env.example` — plantilla de variables de entorno

## Repositorios del sistema

- [discovery-service](https://github.com/jjrmch/discovery-service)
- [gateway-service](https://github.com/jjrmch/gateway-service)
- [catalog-service](https://github.com/jjrmch/catalog-service)
- [transactions-service](https://github.com/jjrmch/transactions-service)
- [customer-service](https://github.com/jjrmch/customer-service)
- [biblioteca-frontend](https://github.com/jjrmch/biblioteca-frontend)

## Por mejorar

- El healthcheck de PostgreSQL asume el usuario `admin` y la BD `biblioteca`; si se cambian en `.env`, hay que ajustarlo.
- Los scripts de seed no son idempotentes: si se ejecutan dos veces, duplican los datos.

## Licencia

MIT
