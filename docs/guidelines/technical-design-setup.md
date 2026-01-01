# Technical Design & Setup Guideline

This document defines the rules and principles used to derive
the Engineering Foundation.

## Goals
- Enable reproducible local development
- Enable CI-based validation
- Support PoC and peak testing
- Enforce architectural consistency

## Scope
- Backend: Spring Boot (Java)
- Frontend: Angular
- Database: PostgreSQL
- API Gateway: nginx
- Containerization: Docker
- CI: GitHub Actions
- OS target: Linux

## Principles
- Everything runnable via containers
- Configuration via environment variables
- Infrastructure as code
- Explicit architectural decisions (ADR)
- Observability by default
