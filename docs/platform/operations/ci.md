# Platform Operations: CI

## Overview

CI operations validate and package the product on every push to `master` and on pull requests.

This document is intentionally high-level so it can remain stable while pipeline implementation details change.

## Operational Goals

CI currently focuses on:

- building backend and frontend artifacts
- running backend tests
- verifying API contract consistency
- building and publishing container images

## Current Pipeline Shape

The current workflow is a multi-job pipeline in GitHub Actions.

At a high level it performs:

1. backend build and artifact publishing
2. API contract validation against committed contract
3. backend test execution
4. frontend build and artifact publishing
5. backend image build and push
6. frontend image build and push

## Current State

Implemented today:

- CI workflow orchestration in GitHub Actions
- contract check script integration in CI
- artifact passing between jobs
- Docker image publishing for API and frontend

Evolving:

- job ordering and gating rules
- validation depth and test coverage
- release and promotion strategy integration

## Boundaries

- This guide explains CI operations at system level, not step-by-step commands.
- Exact CI behavior is defined by the current workflow file and scripts.

## Related Files

- CI workflow: [.github/workflows/ci.yml](/home/devon90/Desktop/engineering-foundation/.github/workflows/ci.yml)
- Contract check script: [scripts/ci/api-diff-ci.sh](/home/devon90/Desktop/engineering-foundation/scripts/ci/api-diff-ci.sh)