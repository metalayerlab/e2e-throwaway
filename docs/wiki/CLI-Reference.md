# CLI Reference

`e2e-throwaway --help` lists the commands. `e2e-throwaway <command> --help` shows a command's options.

## Commands

Generated from the code: don't edit, run `uv run scripts/gen-wiki.py`.

<!-- generated:start cli -->
### `e2e-throwaway config`

Print the effective configuration and where each value came from. Secrets are masked.

| Option | Environment variable | Description |
|---|---|---|
| `--config`, `-c` | `E2E_THROWAWAY_CONFIG` | Config file (default /etc/e2e-throwaway/config.yaml; missing is fine). |

### `e2e-throwaway serve`

Run the HTTP server.

| Option | Environment variable | Description |
|---|---|---|
| `--config`, `-c` | `E2E_THROWAWAY_CONFIG` | Config file (default /etc/e2e-throwaway/config.yaml; missing is fine). |

### `e2e-throwaway version`

Print the version.
<!-- generated:end cli -->

## Exit codes

| Code | Meaning |
|---|---|
| 0 | Success |
| 1 | Failure while running |
| 2 | Bad usage or invalid configuration |

Examples:

```sh
e2e-throwaway version                          # prints the version
e2e-throwaway config -c ./config.yaml          # effective settings and their sources
e2e-throwaway serve                            # listen on 0.0.0.0:8080
E2E_THROWAWAY_LISTEN_PORT=9000 e2e-throwaway serve
```

An invalid configuration prints one `error: ...` line to stderr and exits with code 2. There are no project-specific exit codes.
