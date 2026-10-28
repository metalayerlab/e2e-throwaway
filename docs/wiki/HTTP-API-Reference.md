# HTTP API Reference

The server listens on port 8080 by default. The live OpenAPI schema is served at `/openapi.json`, and interactive docs at `/docs`.

## Endpoints

Generated from the code: don't edit the table, run `uv run scripts/gen-wiki.py`.

<!-- generated:start http-api -->
| Method | Path | Summary |
|---|---|---|
| `GET` | `/healthz` | Liveness: the process is up |
| `GET` | `/hello` | A friendly greeting |
| `GET` | `/readyz` | Readiness: able to serve requests |
| `GET` | `/version` | The running version |
<!-- generated:end http-api -->

`/healthz` (liveness) answers as long as the process runs. `/readyz` (readiness) answers 503 while the service can't serve, for example while a dependency is down. Orchestrators should restart on the first and route traffic on the second.

`/version` returns `{"version": "<installed version>"}`. The health endpoints return `{"status": "ok"}` and `{"status": "ready"}`.

### `GET /hello`

Returns a greeting, for checking the API end to end.

```json
{"message": "hello"}
```

No parameters, and no errors beyond the defaults.

## Authentication

None. The API has no authentication, and every endpoint answers any client that can reach the port. Restrict access with the network (bind address, NetworkPolicy) or a reverse proxy.

## Errors

Errors are JSON: `{"detail": "<message>"}`, with a 4xx status for a client mistake and 5xx for a server-side failure.

| Status | When | What to do |
|---|---|---|
| 404 | Unknown path | Check the path against the endpoint table. |
| 405 | Wrong method; all endpoints are `GET` | Use `GET`. |
| 503 | Reserved for `/readyz` when the service cannot serve (not returned yet) | Retry later; route traffic elsewhere. |
