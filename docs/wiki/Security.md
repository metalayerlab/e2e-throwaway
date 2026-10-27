# Security

## Threat model

<!-- guidance: what this protects, from whom, and what is out of scope. What's exposed (ports, endpoints), who should be able to reach it, what it trusts (headers, upstreams, input files), and what an attacker gains if it is compromised. -->

## Secrets

- Secrets are read from files only (`E2E_THROWAWAY_<KEY>_FILE`), never from the config file. See [In-Depth Configuration](In-Depth-Configuration#secrets).
- Values are never logged. Logs and `e2e-throwaway config` show where a value came from, never the value itself.
- CI scans every commit with gitleaks, and secrets in history fail the build.

<!-- guidance: list each secret, what it grants, and how to rotate it. -->

## Hardening

- **Container:** runs as uid 1000 (after root fixes the state directory's ownership), with a read-only root filesystem and all capabilities dropped (Compose/Kubernetes manifests).
- **Kubernetes:** *restricted* Pod Security Standard, `seccompProfile: RuntimeDefault`, no service-account token, and a NetworkPolicy that admits only the ingress controller.
- **systemd:** a dedicated system user, `ProtectSystem=strict`, no capabilities, a system-call filter, and restricted address families.
- **Supply chain:** dependencies are pinned in the lock file and updated weekly by Dependabot. GitHub Actions are pinned to commit SHAs.

<!-- guidance: input validation, authentication and authorisation, rate limiting: what this project does and where. -->

## Reporting a vulnerability

Report privately through [GitHub security advisories](https://github.com/metalayerlab/e2e-throwaway/security/advisories/new), never in a public issue.
