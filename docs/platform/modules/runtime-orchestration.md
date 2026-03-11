# Platform Module: Runtime Orchestration

## Purpose

The runtime orchestration module defines how platform-managed services are composed and executed in concrete environments. It combines shared Docker Compose definitions, environment-specific overlays, and orchestration scripts that deploy and validate runnable stacks.

## Responsibilities

- define the shared runtime service topology
- adapt the runtime for specific environments through overlays
- select runtime images through injected environment configuration
- provide environment-specific orchestration flows for startup, validation, and teardown

## Main Building Blocks

- shared runtime base: [infra/runtime/base/docker-compose.base.yml](/home/devon90/Desktop/engineering-foundation/infra/runtime/base/docker-compose.base.yml)
- development overlay: [infra/runtime/dev/docker-compose.dev.yml](/home/devon90/Desktop/engineering-foundation/infra/runtime/dev/docker-compose.dev.yml)
- environment variables: [infra/runtime/env](/home/devon90/Desktop/engineering-foundation/infra/runtime/env)
- local runtime composition: [infra/local/docker-compose-local.yml](/home/devon90/Desktop/engineering-foundation/infra/local/docker-compose-local.yml)
- development orchestration script: [scripts/deploy/deploy-DEV.sh](/home/devon90/Desktop/engineering-foundation/scripts/deploy/deploy-DEV.sh)

## Runtime Model

The module uses a layered composition model:

- a base compose file defines common services
- overlays refine the base for a specific target environment
- environment files inject values such as image selection and service configuration
- orchestration scripts run compose commands and perform environment-specific validation flows

## Current State

The runtime orchestration module is implemented unevenly across environments.

Implemented today:

- shared base runtime composition
- local runtime composition for developer builds
- development overlay for CI-produced images
- development deployment-and-test orchestration script

Reserved but not yet implemented fully:

- dedicated test runtime implementation
- dedicated production runtime implementation

## Validation and Promotion Role

The development orchestration path does more than start containers. It also validates that the selected image exists, checks that it matches the current CI output model, runs development environment checks, and promotes approved images to development-specific tags.

That makes this module the bridge between CI-produced artifacts and environment-level runtime approval.

## How It Fits the Platform

Runtime orchestration consumes outputs from CI/CD, configuration from environment files, and checks from the scripts and tests directories. It provides the execution layer that turns versioned build artifacts into a running environment.

## Related Files

- [infra/runtime/base/docker-compose.base.yml](/home/devon90/Desktop/engineering-foundation/infra/runtime/base/docker-compose.base.yml)
- [infra/runtime/dev/docker-compose.dev.yml](/home/devon90/Desktop/engineering-foundation/infra/runtime/dev/docker-compose.dev.yml)
- [infra/local/docker-compose-local.yml](/home/devon90/Desktop/engineering-foundation/infra/local/docker-compose-local.yml)
- [scripts/deploy/deploy-DEV.sh](/home/devon90/Desktop/engineering-foundation/scripts/deploy/deploy-DEV.sh)
- [infra/runtime/dev/README.md](/home/devon90/Desktop/engineering-foundation/infra/runtime/dev/README.md)