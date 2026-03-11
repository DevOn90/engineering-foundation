# Platform Module: GitHub CI

## Purpose

The GitHub CI module provides repository-hosted automation for validation, build, and publish flows. It is implemented through GitHub Actions workflows and CI-specific validation scripts.

## Entry Points

- workflow definition: [.github/workflows/ci.yml](/home/devon90/Desktop/engineering-foundation/.github/workflows/ci.yml)
- CI contract validation script: [scripts/ci/api-diff-ci.sh](/home/devon90/Desktop/engineering-foundation/scripts/ci/api-diff-ci.sh)

## Responsibilities

- orchestrate repository validation on push and pull request events
- build backend and frontend deliverables
- validate API contract alignment in a CI-safe way
- publish container images for downstream runtime environments

## Module Structure

- workflow orchestration in GitHub Actions
- CI-specific OpenAPI diff check that runs without local Docker Compose
- integration with GitHub-hosted secrets for authenticated registry publishing

## Current State

The GitHub CI module is actively implemented.

Current workflow responsibilities include:

- repository structure validation
- backend build
- API contract validation
- backend tests
- frontend build
- backend and frontend container publish flows

At the module level, this is the primary automated platform gate for repository changes.

## Relationship to Other Modules

- consumes application code from the monorepo
- validates documented API contract against generated contract output
- publishes container images consumed by the runtime orchestration module
- depends on the secrets model for registry authentication

## Local Versus CI Validation

This module has its own CI-specific contract check script instead of reusing the local script unchanged. That separation is intentional: local validation relies on local runtime composition, while CI validation uses the already-built application artifact and CI runtime conditions.

## Related Files

- [.github/workflows/ci.yml](/home/devon90/Desktop/engineering-foundation/.github/workflows/ci.yml)
- [scripts/ci/api-diff-ci.sh](/home/devon90/Desktop/engineering-foundation/scripts/ci/api-diff-ci.sh)
- [scripts/ci/api-diff.sh](/home/devon90/Desktop/engineering-foundation/scripts/ci/api-diff.sh)