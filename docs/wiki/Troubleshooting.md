# Troubleshooting

## Diagnostics

- **Effective configuration:** `e2e-throwaway config` prints every setting and where it came from (default, file, env var). Secrets are masked.
- **More logging:** `E2E_THROWAWAY_LOG_LEVEL=DEBUG`.
- **Health:** `curl http://127.0.0.1:8080/healthz` (alive) and `/readyz` (ready to serve).
- **Container:** `docker logs e2e-throwaway`, and `docker inspect --format '{{json .State.Health}}' e2e-throwaway`.
- **Kubernetes:** `kubectl -n e2e-throwaway logs deploy/e2e-throwaway` and `kubectl -n e2e-throwaway describe pod`.
- **systemd:** `journalctl -u e2e-throwaway -e` and `systemctl status e2e-throwaway`.

## Common problems

<!-- guidance: one ### heading per symptom, in the user's words ("Exits with 'cannot read ..._FILE'"), then the cause and the fix. Add one whenever a bug report or a support question shows a new failure mode. -->

### `error: cannot read E2E_THROWAWAY_..._FILE`

The file named by a `_FILE` variable doesn't exist, or the process can't read it. Check the path inside the container or unit, and the file's owner and mode: the process runs as uid 1000 / the `e2e-throwaway` user.
