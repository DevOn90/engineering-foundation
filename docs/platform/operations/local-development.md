# Platform Operations: Local Development

## Overview

Local development operations provide a single entry workflow for developers to initialize and manage the local runtime environment.

This document stays intentionally high-level because commands and implementation details evolve frequently.

## Operational Flow

At a high level, local development follows this sequence:

1. initialize repository-local prerequisites
2. retrieve or refresh environment configuration
3. start local runtime services
4. stop or reset services as needed

## Entry Point

The local workflow is operated through one script entry point:

- `scripts/local/local.sh`

That entry point dispatches operational commands such as init, environment sync, start, stop, and reset.

## Current State

Implemented today:

- unified local command entry script
- shared logging behavior for local scripts
- local runtime orchestration wiring through Docker Compose

Evolving:

- helper command implementations and exact command behavior
- local initialization details and environment retrieval details

## Boundaries

- This guide describes operational intent, not command internals.
- Script-level behavior is defined by the current implementation in `scripts/local/`.
- Runtime topology is defined in infrastructure compose files.

## Related Files

- Local entry script: [scripts/local/local.sh](/home/devon90/Desktop/engineering-foundation/scripts/local/local.sh)
- Local scripts notes: [scripts/local/README.local.md](/home/devon90/Desktop/engineering-foundation/scripts/local/README.local.md)
- Local runtime compose: [infra/local/docker-compose-local.yml](/home/devon90/Desktop/engineering-foundation/infra/local/docker-compose-local.yml)