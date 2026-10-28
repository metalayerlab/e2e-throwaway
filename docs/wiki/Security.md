# Security

## Threat model

The service exposes one HTTP port (8080 by default) with read-only `GET` endpoints that return static JSON. It has no authentication, so only trusted clients should reach it: the Compose file binds to `127.0.0.1` and the Kubernetes NetworkPolicy admits only the ingress controller. It reads a YAML config file and environment variables, which are trusted operator input; `X-Forwarded-*` headers are honoured (`proxy_headers=True`), so expose it only behind a proxy you control. It holds no data, so a compromise gains little beyond the container's own permissions. Anything beyond the process itself is out of scope.

## Secrets

- Secrets are read from files only (`E2E_THROWAWAY_<KEY>_FILE`), never from the config file. See [In-Depth Configuration](In-Depth-Configuration#secrets).
- Values are never logged. Logs and `e2e-throwaway config` show where a value came from, never the value itself.
- CI scans every commit with gitleaks, and secrets in history fail the build.

There are no secrets today. When one is added, list it here with what it grants and how to rotate it.

## Hardening

- **Container:** runs as uid 1000 (after root fixes the state directory's ownership), with a read-only root filesystem and all capabilities dropped (Compose/Kubernetes manifests).
- **Kubernetes:** *restricted* Pod Security Standard, `seccompProfile: RuntimeDefault`, no service-account token, and a NetworkPolicy that admits only the ingress controller.
- **systemd:** a dedicated system user, `ProtectSystem=strict`, no capabilities, a system-call filter, and restricted address families.
- **Supply chain:** dependencies are pinned in the lock file and updated weekly by Dependabot. GitHub Actions are pinned to commit SHAs.
- **Dependency auto-merge:** Dependabot patch updates get auto-merge queued by `dependabot-automerge.yml`: they still need a code owner's approval, then merge once CI passes.

Input validation: configuration values are type-checked and range-checked at startup, and the endpoints take no user input. Authentication, authorisation and rate limiting are not implemented; do them at the reverse proxy if needed.

## Reporting a vulnerability

Report privately through [GitHub security advisories](https://github.com/metalayerlab/e2e-throwaway/security/advisories/new), never in a public issue.
