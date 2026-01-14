# Local Development Environment (Local-Dev)

This folder contains the infrastructure setup for running the **Local Development (Local-Dev) environment** for the application.  
It uses **Docker Compose** to build and run the frontend, backend, database, etc. locally.

---

## Prerequisites

- Docker >= 20.10
- Docker Compose >= 1.29
- Java 17+ (if building locally)
- Spring Boot source code available under `/apps/api`
- .env file in the root of this folder with at least:
    - see **.env.example**

---

## Environment Variables

Configuration is managed via `.env` file.  

1. Copy the example:

```bash
cp .env.example .env
```
2. Update the variables in .env:
    > Note: The SPRING_PROFILES_ACTIVE must be set to **local** to load `application-local.yml` Spring Boot profile.

## Usage Local-Dev Environment

Build and start containers:
```bash
cd apps/infra/01_local-dev
docker compose up -d --build
```
Check logs:
```bash
docker compose logs -f api-local-dev
docker compose logs -f db-local-dev
```
Stop the environment:
```bash
dcoker compose down
```
Containers are named `api-local-dev` and `db-local-dev`.

## Logs
Application logs are mounted to host directory:
```bash
../../logs/api
```
This allows you to inspect logs outside the containers.

## Notes
- Database data is persisted in the Docker volume local-db-data.
- The local-dev environment is intended for developer testing only, not CI/CD.
- For testing pipelines and image promotion, see `infra/02_dev`.
