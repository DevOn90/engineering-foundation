## common.sh

Version: **1.1.0**

`common.sh` provides shared helpers for all local scripts.

### Guarantees
- Consistent logging format
- Log levels: ERROR, WARN, INFO, DEBUG, TRACE
- `LOG_LEVEL` environment variable controls verbosity
- `CI=true` switches logs to JSON format
- Colors are applied only for human-readable output
- `--no-color` command line flag disables color log output

### Stability
This file is considered **stable**.
Breaking changes require a version bump.