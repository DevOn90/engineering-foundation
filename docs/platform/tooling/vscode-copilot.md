# Platform Tooling: VS Code + Copilot

## Overview

This document describes how VS Code and GitHub Copilot are currently configured in this repository.

The repository currently uses a minimal setup: one workspace settings file under `.vscode/` with Copilot enabled.

## Current Configuration

VS Code workspace settings are defined in `.vscode/settings.json`.

Current settings:

- `java.configuration.updateBuildConfiguration`: `interactive`
- `github.copilot.enable`: enabled for all file types (`"*": true`)

## Scope and Boundaries

- Configuration is currently limited to workspace editor settings.
- There are no committed extension recommendations in `.vscode/extensions.json`.
- There are no repository-level Copilot instruction files in the workspace root.
- No custom prompt libraries or agent-mode customization files are currently versioned in this repository.

## Current State

The VS Code + Copilot tooling is intentionally lightweight.

Implemented today:

- workspace-level VS Code settings
- Copilot enablement at workspace scope

Not implemented yet:

- repository-scoped Copilot coding instructions
- VS Code extension recommendations for onboarding
- shared team prompt catalog or agent profiles

## How It Fits the Platform

VS Code and Copilot are developer productivity tooling. They do not change runtime behavior directly; they support authoring and navigation for platform and product code.

## Related Files

- Workspace settings: [.vscode/settings.json](/home/devon90/Desktop/engineering-foundation/.vscode/settings.json)
- Tooling index: [docs/README.md](/home/devon90/Desktop/engineering-foundation/docs/README.md)