# Platform Module: Local Development

## Purpose

The local development module provides the repository entry point for developer-operated local workflows. It is designed as a command-dispatch script with shared logging and helper scripts for environment initialization and local stack lifecycle operations.

## Entry Point

- Main command entry: [scripts/local/local.sh](/home/devon90/Desktop/engineering-foundation/scripts/local/local.sh)

## Responsibilities

- provide a single local CLI for common developer actions
- centralize logging behavior for local scripts
- separate command dispatch from command implementation
- coordinate local initialization, environment retrieval, and stack lifecycle actions

## Command Surface

The local entry script currently exposes these commands:

- `init`
- `pull-env`
- `up`
- `down`
- `reset`
- `help`

The entry script also supports log-related flags such as quiet, verbose, trace, CI output mode, and no-color mode.

## Structure

- command dispatcher: [scripts/local/local.sh](/home/devon90/Desktop/engineering-foundation/scripts/local/local.sh)
- shared helpers and logging contract: [scripts/local/helpers/common.sh](/home/devon90/Desktop/engineering-foundation/scripts/local/helpers/common.sh)
- command implementations: [scripts/local/helpers](/home/devon90/Desktop/engineering-foundation/scripts/local/helpers)
- local runtime composition: [infra/local/docker-compose-local.yml](/home/devon90/Desktop/engineering-foundation/infra/local/docker-compose-local.yml)
- local runtime notes: [infra/local/README.md](/home/devon90/Desktop/engineering-foundation/infra/local/README.md)

## Logging and Script Contract

The local development module is built around a shared shell helper contract.

- local scripts source a common helper library
- logging behavior is standardized across scripts
- non-CI runs are routed into timestamped local log files
- CI mode switches logging to structured output

This gives the module a consistent operational interface even though individual helper scripts are still evolving.

## Current State

The local development module is partially implemented.

Implemented today:

- top-level command dispatch
- shared logging, guards, and path resolution helpers
- local log file routing
- local Docker Compose definition for backend and database services

Scaffolded or incomplete today:

- `pull-env`, `up`, `down`, and `reset` helper logic
- full `init` workflow beyond bootstrap linkage and intent logging

The module already defines its public interface clearly, but several command implementations are still placeholders.

## How It Fits the Platform

This module sits between repository bootstrap and local runtime usage. It gives developers a consistent command surface while delegating exact environment and Docker behavior to helper scripts and runtime configuration.

## Related Files

- [scripts/local/local.sh](/home/devon90/Desktop/engineering-foundation/scripts/local/local.sh)
- [scripts/local/helpers/common.sh](/home/devon90/Desktop/engineering-foundation/scripts/local/helpers/common.sh)
- [scripts/local/helpers/init.sh](/home/devon90/Desktop/engineering-foundation/scripts/local/helpers/init.sh)
- [infra/local/docker-compose-local.yml](/home/devon90/Desktop/engineering-foundation/infra/local/docker-compose-local.yml)
- [scripts/local/README.local.md](/home/devon90/Desktop/engineering-foundation/scripts/local/README.local.md)