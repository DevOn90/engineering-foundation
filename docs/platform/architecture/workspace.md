# Platform Architecture: Workspace

## Overview

The workspace is the monorepo root. It defines the top-level structure of all source-controlled content and separates it from generated runtime artifacts produced during development and CI execution.

This document describes the workspace layout, what is committed versus generated, and where generated artifacts currently live.

## Workspace Layout

```
/                            # Repository root
├── apps/                    # Product applications (source code)
│   ├── api/                 # Spring Boot backend
│   ├── frontend/            # Angular frontend
│   └── auth/                # Auth service (placeholder)
├── docs/                    # Engineering documentation
├── infra/                   # Infrastructure configuration (Docker Compose, env files)
├── scripts/                 # Automation scripts (bootstrap, local dev, CI, deploy, tests)
└── logs/                    # Generated runtime artifacts (not source, see below)
```

## Source-Controlled vs Generated

| Directory | Committed | Purpose |
|-----------|-----------|---------|
| `apps/` | yes | application source code |
| `docs/` | yes | engineering documentation |
| `infra/` | yes | runtime and infrastructure configuration |
| `scripts/` | yes | automation and developer tooling |
| `logs/` | structure only | generated log files are excluded via `.gitignore` |

Log file contents (`*.log`, `*.gz`) are excluded by `.gitignore`. The directory structure is committed to preserve the layout across clones.

## Generated Artifacts: Logs

Logs are currently stored under `logs/` at the repository root. The structure is environment-first:

```
logs/
├── local/
│   ├── docker/              # Docker infrastructure logs
│   └── shell/               # Script execution logs
├── dev/
│   ├── docker/              # Service logs from running containers
│   └── shell/               # Script and test logs (smoke, health, sanity, blackbox)
├── test/
│   ├── docker/
│   └── shell/
└── prod/
    ├── docker/
    └── shell/
```

Logs are produced in two ways:
- **Docker logs** (`docker/`): written by services inside containers, mounted via Docker Compose volume binds (e.g. `logs/dev/docker:/logs`)
- **Shell logs** (`shell/`): written directly by automation scripts and test runners

## Known Limitations

The `shell/` directories currently mix script execution logs and test verification logs (smoke, health, sanity, blackbox). This makes retention policies and failure triage harder as the project grows.

A restructuring of workspace artifacts — separating log concerns by category and isolating all generated artifacts under a single uncommitted root — is a planned architectural decision. See ADRs for status.

## Invariants

- generated artifact contents are never committed to source control
- log directory structure is versioned to ensure consistent layout across developer machines
- each environment has its own isolated log path

## Related Files

- Log structure documentation: [logs/README.md](/home/devon90/Desktop/engineering-foundation/logs/README.md)
- Local Docker Compose (volume mount): [infra/local/docker-compose-local.yml](/home/devon90/Desktop/engineering-foundation/infra/local/docker-compose-local.yml)
- Git ignore rules: [.gitignore](/home/devon90/Desktop/engineering-foundation/.gitignore)