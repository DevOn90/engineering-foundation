# Platform Operations: Deployment

## Overview

Deployment operations move CI-produced container images into runtime environments with environment-specific configuration and validation.

This document remains high-level by design because deployment procedures are expected to evolve.

## Operational Flow

Deployment currently follows a staged flow:

1. select immutable image tag produced by CI
2. compose runtime using environment-specific configuration
3. execute environment validation checks
4. promote image when validation succeeds

## Current State

Implemented today:

- scripted DEV deployment and validation flow
- environment-file-driven image selection
- test-gated promotion to DEV-approved image tags

Evolving:

- deployment flows for additional environments
- promotion and rollback operational model
- deployment automation integration across environments

## Boundaries

- This guide describes deployment intent and lifecycle only.
- Exact deployment commands and checks are defined in deployment scripts and runtime compose files.

## Related Files

- DEV deployment script: [scripts/deploy/deploy-DEV.sh](/home/devon90/Desktop/engineering-foundation/scripts/deploy/deploy-DEV.sh)
- Runtime base compose: [infra/runtime/base/docker-compose.base.yml](/home/devon90/Desktop/engineering-foundation/infra/runtime/base/docker-compose.base.yml)
- Runtime DEV overlay: [infra/runtime/dev/docker-compose.dev.yml](/home/devon90/Desktop/engineering-foundation/infra/runtime/dev/docker-compose.dev.yml)
- Runtime environment files: [infra/runtime/env](/home/devon90/Desktop/engineering-foundation/infra/runtime/env)