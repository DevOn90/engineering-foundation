# Platform Module: Bootstrap

## Purpose

The bootstrap module is the repository-level onboarding entry point for a developer machine. Its role is to verify that the repository can be used safely on the current machine and to record bootstrap state through a marker file.

This module is intentionally separate from application runtime setup. It prepares the repository and machine context rather than starting services.

## Entry Point

- Main script: [scripts/bootstrap/bootstrap.sh](/home/devon90/Desktop/engineering-foundation/scripts/bootstrap/bootstrap.sh)

## Responsibilities

- validate bootstrap execution mode
- manage repository bootstrap state through a marker file
- verify that an existing marker is structurally valid and belongs to the current repository
- provide a stable place for future one-time setup tasks

## Structure

- bootstrap script logic: [scripts/bootstrap/bootstrap.sh](/home/devon90/Desktop/engineering-foundation/scripts/bootstrap/bootstrap.sh)
- bootstrap tests: [scripts/bootstrap/tests](/home/devon90/Desktop/engineering-foundation/scripts/bootstrap/tests)
- shared helper dependency: [scripts/local/helpers/common.sh](/home/devon90/Desktop/engineering-foundation/scripts/local/helpers/common.sh)
- design notes: [scripts/bootstrap/pseudo-code.md](/home/devon90/Desktop/engineering-foundation/scripts/bootstrap/pseudo-code.md)

## Execution Model

The script supports three execution modes:

- normal bootstrap
- status-only check
- forced re-bootstrap

Bootstrap state is represented by a repository marker file created under the bootstrap module directory. The marker is validated against a template and checked against the current repository root.

## Current State

The bootstrap module is partially implemented.

Implemented today:

- flag parsing
- marker creation
- marker validation against schema and repository root
- bootstrap status check
- unit and integration test structure for bootstrap behavior

Not yet implemented fully:

- concrete bootstrap tasks
- full force workflow
- full normal bootstrap workflow

This means the module already defines the bootstrap contract and state model, but the provisioning work behind that contract is still incomplete.

## How It Fits the Platform

Bootstrap is the earliest platform entry point for a fresh clone. It is intended to sit before local development workflows and before any runtime orchestration. In practice, local development helpers already refer back to bootstrap state and shared helper functions.

## Related Files

- [scripts/bootstrap/bootstrap.sh](/home/devon90/Desktop/engineering-foundation/scripts/bootstrap/bootstrap.sh)
- [scripts/bootstrap/tests/run_all.sh](/home/devon90/Desktop/engineering-foundation/scripts/bootstrap/tests/run_all.sh)
- [scripts/bootstrap/pseudo-code.md](/home/devon90/Desktop/engineering-foundation/scripts/bootstrap/pseudo-code.md)
- [scripts/local/helpers/common.sh](/home/devon90/Desktop/engineering-foundation/scripts/local/helpers/common.sh)