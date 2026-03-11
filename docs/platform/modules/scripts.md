# Platform Module: Scripts

## Purpose

The scripts module is the platform automation surface for repository setup, validation, local workflows, deployment orchestration, and environment checks. It groups operational shell entry points by responsibility so they can evolve independently while still following shared conventions.

## Top-Level Structure

- bootstrap scripts: [scripts/bootstrap](/home/devon90/Desktop/engineering-foundation/scripts/bootstrap)
- CI validation scripts: [scripts/ci](/home/devon90/Desktop/engineering-foundation/scripts/ci)
- deployment orchestration scripts: [scripts/deploy](/home/devon90/Desktop/engineering-foundation/scripts/deploy)
- local workflow scripts: [scripts/local](/home/devon90/Desktop/engineering-foundation/scripts/local)
- test scripts: [scripts/tests](/home/devon90/Desktop/engineering-foundation/scripts/tests)

## Responsibilities

- expose automation entry points outside application code
- separate local, CI, deploy, and test concerns into distinct script domains
- centralize shared helper behavior where appropriate
- provide shell-based glue between code, containers, environment configuration, and validation steps

## Script Domains

### Bootstrap

Bootstrap scripts manage repository setup state and bootstrap validation.

### CI

CI scripts provide validation logic that is called by hooks or workflows, especially around API contract consistency.

### Deploy

Deployment scripts orchestrate environment startup, validation, and image promotion flows.

### Local

Local scripts provide a CLI-style developer interface with shared logging helpers and command dispatch.

### Tests

Test scripts contain environment-level checks used by deployment or validation workflows.

## Current State

The scripts module is mixed in maturity.

More complete areas:

- CI contract validation scripts
- development deployment orchestration
- local command dispatcher and shared logging helpers
- bootstrap test structure

Less complete areas:

- several local helper commands are placeholders
- several development environment tests are placeholders
- bootstrap task execution is not yet fully implemented

This makes the scripts directory an active platform workspace rather than a fully stabilized automation library.

## Shared Conventions

From the inspected scripts, several conventions are already present:

- shell scripts use strict mode
- helper reuse is favored over repeating path and logging logic
- script responsibilities are separated by directory rather than merged into one large automation entry point
- logs and environment files are treated as external runtime concerns rather than embedded constants

## Related Files

- [scripts/bootstrap/bootstrap.sh](/home/devon90/Desktop/engineering-foundation/scripts/bootstrap/bootstrap.sh)
- [scripts/ci/api-diff.sh](/home/devon90/Desktop/engineering-foundation/scripts/ci/api-diff.sh)
- [scripts/deploy/deploy-DEV.sh](/home/devon90/Desktop/engineering-foundation/scripts/deploy/deploy-DEV.sh)
- [scripts/local/local.sh](/home/devon90/Desktop/engineering-foundation/scripts/local/local.sh)
- [scripts/tests/common](/home/devon90/Desktop/engineering-foundation/scripts/tests/common)