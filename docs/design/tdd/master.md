# Technical Design Document – Master

## Purpose
Defines system-wide architectural rules and constraints.

## System Overview
The system consists of:
- Angular SPA
- API Gateway (nginx)
- Backend services (Spring Boot)
- Authentication service
- PostgreSQL database

## Cross-Cutting Concerns
- Configuration via environment variables
- Logging to stdout
- Health checks
- Observability hooks
- CI-driven validation

## Repository Structure Rules
- /apps contains runnable services
- /infra contains deployment concerns
- /docs contains all architectural documentation

## Referenced ADRs
See ../adr directory.
