# Platform Library: Config

## Purpose

The config library provides the primitives for managing script-level configuration and repository state markers. It lives inside `common.sh` alongside the other platform helpers.

This library addresses two distinct configuration concerns:

- **environment file-based runtime configuration** — values consumed by running services
- **INI marker files** — lightweight state files tracking setup milestones

## File

- [scripts/local/helpers/common.sh](/home/devon90/Desktop/engineering-foundation/scripts/local/helpers/common.sh)

## Environment File Model

Runtime configuration is provided through environment files under `infra/runtime/env/`. The library provides the directory reference (`ENV_DIR`) that scripts use to locate these files, but loading them is left to the callers.

Environment files are not committed with real values. Template files (`*.env.example`) are committed to show the expected shape.

See [docs/platform/architecture/secrets.md](/home/devon90/Desktop/engineering-foundation/docs/platform/architecture/secrets.md) for the broader model.

## INI Marker Files

Marker files record repository-level state milestones in a simple INI key-value format. They are used to track whether repository setup operations have been completed and are validated against a companion template.

### Marker files in use

| Marker | Template | Purpose |
|--------|----------|---------|
| `.repo-bootstrap-marker.ini` | `.repo-bootstrap-marker.template` | Records that repository bootstrap has run |
| `.local-init-marker.ini` | `.local-init-marker.template` | Records that local initialization has run |

Templates define the expected key structure. Real marker files are gitignored.

### Schema Validation

The library provides:

```bash
validate_ini_schema <template> <actual>
```

This compares the key set of the actual marker file against the template and fails if keys are missing or unexpected. It does not validate values, only structure.

### State Guards

The library exposes a guard that scripts call to assert preconditions before proceeding:

```bash
require_initialized
```

This checks that the local initialization marker exists. Scripts that depend on a fully initialized local environment fail early and descriptively instead of encountering undefined behavior later.

## Related Files

- [scripts/local/helpers/common.sh](/home/devon90/Desktop/engineering-foundation/scripts/local/helpers/common.sh)
- [scripts/local/helpers/.local-init-marker.template](/home/devon90/Desktop/engineering-foundation/scripts/local/helpers/.local-init-marker.template)
- [scripts/bootstrap/bootstrap.sh](/home/devon90/Desktop/engineering-foundation/scripts/bootstrap/bootstrap.sh)
- [infra/runtime/env](/home/devon90/Desktop/engineering-foundation/infra/runtime/env)
- [docs/platform/architecture/environments.md](/home/devon90/Desktop/engineering-foundation/docs/platform/architecture/environments.md)