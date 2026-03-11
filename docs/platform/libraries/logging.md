# Platform Library: Logging

## Purpose

The logging library provides a consistent, level-aware logging interface for all platform scripts. It lives inside `common.sh` and is available to any script that sources it.

Logging behavior adapts to execution context: human-readable with color in terminal mode, JSON structured output in CI mode.

## File

- [scripts/local/helpers/common.sh](/home/devon90/Desktop/engineering-foundation/scripts/local/helpers/common.sh)

## Log Functions

| Function | Level | Notes |
|----------|-------|-------|
| `log` | INFO | Standard operational output |
| `warn` | WARN | Advisory, colored yellow in terminal |
| `error` | ERROR | Error output, colored red in terminal |
| `fail` | ERROR | Calls `error` then returns 1 |
| `debug` | DEBUG | Developer diagnostics, colored blue |
| `trace` | TRACE | Execution path detail, dimmed |

## Log Levels

Verbosity is controlled by the `LOG_LEVEL` environment variable:

```
ERROR < WARN < INFO < DEBUG < TRACE
```

Only messages at or below the configured level are emitted. Default is `INFO`.

## Log Format

**Terminal mode (default):**
```
[timestamp][LEVEL][LOG_CONTEXT][script_name]: message
```

**CI mode (`CI=true`):**
```json
{"ts":"...","level":"...","context":"...","script":"...","msg":"..."}
```

## Configuration Variables

| Variable | Default | Purpose |
|----------|---------|--------|
| `LOG_LEVEL` | `INFO` | Controls verbosity threshold |
| `CI` | `false` | Switches to JSON structured output |
| `NO_COLOR` | `false` | Disables ANSI color codes |
| `LOG_CONTEXT` | `LOG_CONTEXT` | Scoping label shown in each log line |
| `LOG_FD` | `1` | File descriptor used by logging functions |

## Log Routing

In local (non-CI) mode, the `local.sh` entry script routes logs through a dedicated file descriptor (`LOG_FD=5`) into a `tee` pipeline that simultaneously:

- writes colorized output to the terminal
- writes ANSI-stripped output to a timestamped log file in `logs/local/shell/`

All logging functions write exclusively to `LOG_FD`, which keeps terminal output and log file output consistent and ordered.

In CI mode, logs are emitted as structured JSON to stdout.

## Colors

Colors are applied automatically when the output is a TTY and `NO_COLOR` is not set:

- `DEBUG` → blue
- `TRACE` → dimmed
- `WARN` → yellow
- `ERROR` → red

Colors are suppressed when outputting to a file, in CI mode, or when `--no-color` is passed to the entry script.

## Related Files

- [scripts/local/helpers/common.sh](/home/devon90/Desktop/engineering-foundation/docs/../../../scripts/local/helpers/common.sh)
- [scripts/local/README.local.md](/home/devon90/Desktop/engineering-foundation/scripts/local/README.local.md)
- [docs/platform/libraries/scripts-runtime.md](/home/devon90/Desktop/engineering-foundation/docs/platform/libraries/scripts-runtime.md)