# Platform Module: Git Hooks

## Purpose

The git hooks module provides local repository checks that run automatically during developer commit flows. Its goal is to catch repository-level issues before changes leave the developer machine.

## Entry Point

- pre-commit hook: [.githooks/pre-commit](/home/devon90/Desktop/engineering-foundation/.githooks/pre-commit)

## Responsibilities

- enforce selected local engineering checks before commit
- block commits when mandatory local validation fails
- provide fast feedback before CI re-runs critical checks

## Current Implementation

The current hook implementation is focused on API contract consistency.

Today the pre-commit hook:

- resolves the repository root
- locates the local API contract validation script
- executes the contract diff check before allowing a commit

The hook is structured to allow additional checks later, but only the API contract gate is implemented now.

## Relationship to CI

Git hooks are a local enforcement layer, not the final authority. The same class of important checks must still be enforced in CI. This keeps local feedback fast while preserving server-side validation as the source of merge protection.

## Activation Note

The repository contains the hook implementation under `.githooks`, but the inspected bootstrap and local setup scripts do not yet fully show the final automation path for installing or activating hooks. The hook logic itself is present; setup automation for hook activation should be treated as a separate concern.

## Related Files

- [.githooks/pre-commit](/home/devon90/Desktop/engineering-foundation/.githooks/pre-commit)
- [scripts/ci/api-diff.sh](/home/devon90/Desktop/engineering-foundation/scripts/ci/api-diff.sh)