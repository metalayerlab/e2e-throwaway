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

<!-- guidance: add project-specific exit codes, and worked examples of common invocations. -->
