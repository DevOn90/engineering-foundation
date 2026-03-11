# Platform Library: Script Runtime

## Purpose

The script runtime library is the shared foundation that all platform scripts source before executing any work. It provides a consistent execution context regardless of which script is running or where in the repository it sits.

The library is not an executable script. It is a Bash source file designed to be included at the top of every platform shell script.

## File

- [scripts/local/helpers/common.sh](/home/devon90/Desktop/engineering-foundation/scripts/local/helpers/common.sh)

## Version and Stability

- Version: **2.0.0**
- Stability: **stable**
- Breaking changes require a version bump

## What It Provides

The library is organized around four concerns:

### 1. Shared Path Resolution

On source, the library resolves and exports a consistent set of directory paths:

- `SCRIPT_DIR` — directory of the sourcing script
- `LOCAL_DIR` — `scripts/local`
- `REPO_ROOT` — repository root
- `LOGS_DIR` — `logs/local/shell`
- `INFRA_DIR` — `infra`
- `ENV_DIR` — `infra/runtime/env`

This means scripts do not need to independently resolve their own paths relative to the repository.

### 2. Logging

See [logging.md](/home/devon90/Desktop/engineering-foundation/docs/platform/libraries/logging.md) for the full logging interface.

### 3. Guards

Precondition helpers that exit with an error message if a requirement is not met:

- `require_command <name>` — checks command is available on PATH
- `require_file <path>` — checks file exists
- `require_dir <path>` — checks directory exists
- `require_initialized` — checks repository has been locally initialized

### 4. State and Schema Validation

- `validate_ini_schema <template> <actual>` — validates that an INI file matches the expected key structure of a template
- `timestamp` — returns current timestamp in ISO-like format

## How It Is Used

Every platform script sources the library at the start:

```bash
source "$(cd "${BASH_SOURCE[0]%/*}" && pwd)/helpers/common.sh"
```

All bootstrap scripts, local scripts, test orchestrators, and local helper scripts source from this single file. There is no alternative or platform-specific version.

## Related Files

- [scripts/local/helpers/common.sh](/home/devon90/Desktop/engineering-foundation/scripts/local/helpers/common.sh)
- [scripts/local/README.local.md](/home/devon90/Desktop/engineering-foundation/scripts/local/README.local.md)
- [docs/platform/libraries/logging.md](/home/devon90/Desktop/engineering-foundation/docs/platform/libraries/logging.md)
- [docs/platform/libraries/config.md](/home/devon90/Desktop/engineering-foundation/docs/platform/libraries/config.md)