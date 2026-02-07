## common.sh

Version: **2.0.0**

`common.sh` provides shared helpers for all local scripts.

### Guarantees
- Consistent logging format
    - Example: `[timestamp][level][LOG_CONTEXT][script]: text`
- Log levels: ERROR, WARN, INFO, DEBUG, TRACE
- `LOG_LEVEL` environment variable controls verbosity
- `CI=true` switches logs to JSON format. The flag --ci change `CI` to `true`
    - Example: `./local.sh --ci init`
- Colors are applied only for human-readable output
- `--no-color` command line flag disables color log output
- `LOG_CONTEXT` environment variable allows scoping logs by context
  - Example: `export LOG_CONTEXT="service=api"`
    ```text
    [2026-02-07T16:20:37+0100][INFO][service=api][up.sh]: Starting backend
    ```
  - If `LOG_CONTEXT` is not exported, a placeholder is shown:
    ```text
    [2026-02-07T16:20:37+0100][INFO][LOG_CONTEXT][up.sh]: Starting backend
    ```

### Notes
- All logging functions (`log`, `debug`, `trace`, `warn`, `error`, `fail`) respect `LOG_LEVEL`, `CI`, and `LOG_CONTEXT` environment variables.
- Designed for local development scripts; do not execute directly, always `source`.
- For full usage examples, check the local scripts (`init.sh`, `pull-env.sh`, `up.sh`, etc.).

### Stability
This file is considered **stable**.
Breaking changes require a version bump.