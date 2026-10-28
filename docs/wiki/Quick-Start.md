# Quick Start

From nothing to a working e2e-throwaway in a few minutes. Everything else is in [In-Depth Configuration](In-Depth-Configuration) and [Deployment](Deployment).

## Prerequisites

- Docker (or any OCI runtime)
- For running from source: Python >= 3.13 and [uv](https://docs.astral.sh/uv/)
- Nothing else: the service has no external dependencies, accounts or API keys.

## Install

```sh
docker pull ghcr.io/metalayerlab/e2e-throwaway:latest
```

```sh
uv tool install git+https://github.com/metalayerlab/e2e-throwaway
```

## First run

```sh
docker run -d --name e2e-throwaway -p 127.0.0.1:8080:8080 ghcr.io/metalayerlab/e2e-throwaway:latest
curl http://127.0.0.1:8080/healthz      # {"status":"ok"}
docker exec e2e-throwaway e2e-throwaway config   # the effective configuration
```

Then call the greeting and version endpoints:

```sh
curl http://127.0.0.1:8080/hello       # {"message":"hello"}
curl http://127.0.0.1:8080/version     # {"version":"<installed version>"}
```

See the [HTTP API Reference](HTTP-API-Reference) for all endpoints.

## Next steps

- [In-Depth Configuration](In-Depth-Configuration): every setting
- [Deployment](Deployment): docker, k8s, systemd
- [Troubleshooting](Troubleshooting) if something doesn't work
