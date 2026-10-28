# In-Depth Configuration

## Where configuration comes from

Every setting can be given in four places, and the first one that has it wins:

1. `E2E_THROWAWAY_<KEY>_FILE`: the path of a file holding the value (Docker and Kubernetes secrets)
2. `E2E_THROWAWAY_<KEY>`: an environment variable
3. the YAML config file: `E2E_THROWAWAY_CONFIG` or `--config`, default `/etc/e2e-throwaway/config.yaml`. A missing file is fine.
4. the built-in default

`<KEY>` is the setting's key in upper case, with the dots as underscores: `listen.port` is `E2E_THROWAWAY_LISTEN_PORT`.
`e2e-throwaway config` prints the effective value of every setting and where it came from, with secrets masked.

## Settings

Generated from the code: don't edit the table, run `uv run scripts/gen-wiki.py`.

<!-- generated:start settings -->
| Key | Environment variable | Default | Description |
|---|---|---|---|
| `log_level` | `E2E_THROWAWAY_LOG_LEVEL` | `INFO` | Log level: `DEBUG`, `INFO`, `WARNING` or `ERROR`. |
| `listen.host` | `E2E_THROWAWAY_LISTEN_HOST` | `0.0.0.0` | Address the HTTP server binds to. |
| `listen.port` | `E2E_THROWAWAY_LISTEN_PORT` | `8080` | Port the HTTP server listens on. |
| `state_dir` | `E2E_THROWAWAY_STATE_DIR` | `/var/lib/e2e-throwaway` | Directory for persistent state. |
<!-- generated:end settings -->

`log_level` is case-insensitive and must be one of `DEBUG`, `INFO`, `WARNING` or `ERROR`. `listen.port` must be between 1 and 65535. `listen.host` defaults to all interfaces, which suits a container; use `127.0.0.1` when running directly on a shared host. A value of the wrong type or out of range stops startup with an `error:` line and exit code 2. `state_dir` is not written to yet.

## Secrets

Never put a secret in the config file or in a plain environment variable that `docker inspect` or `ps` would show. Use the `_FILE` variant and mount the value as a file:

- Docker: `E2E_THROWAWAY_<KEY>_FILE=/run/secrets/<name>` with a secrets file or bind mount
- Kubernetes: a Secret mounted as a volume (SOPS-encrypted in the GitOps repo)
- systemd: `LoadCredential=` and `%d/<name>`

This project has no secrets today. A new setting that holds one is declared with `secret=True` and read from its `_FILE` variable.

## Examples

A complete config file with every default is in [contrib/e2e-throwaway.example.yaml](https://github.com/metalayerlab/e2e-throwaway/blob/main/contrib/e2e-throwaway.example.yaml).

Local development, on a non-default port with debug logging:

```sh
E2E_THROWAWAY_LISTEN_HOST=127.0.0.1 E2E_THROWAWAY_LISTEN_PORT=9000 \
E2E_THROWAWAY_LOG_LEVEL=DEBUG e2e-throwaway serve
```

A config file mounted into a container or installed under `/etc`:

```yaml
log_level: WARNING
listen:
  port: 8080
state_dir: /var/lib/e2e-throwaway
```
