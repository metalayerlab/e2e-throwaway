# Deployment

Manifests live in [`contrib/`](https://github.com/metalayerlab/e2e-throwaway/tree/main/contrib), versioned with the code. release-please moves their image tag to each new release. Every option keeps the same hardening: a non-root user, read-only root, no capabilities.

## Docker Compose

```sh
mkdir -p config state
cp contrib/e2e-throwaway.example.yaml config/config.yaml   # edit it
docker compose -f contrib/docker/compose.yml up -d
docker compose -f contrib/docker/compose.yml logs -f
```

The port binds to `127.0.0.1` only: put a reverse proxy (Traefik) in front for TLS and remote access.
The container starts as root only to give `state/` to `PUID:PGID` (default `1000:1000`), then drops to that user.
Secrets go in files mounted read-only, passed as `E2E_THROWAWAY_<KEY>_FILE`.

## Kubernetes

[`contrib/k8s`](https://github.com/metalayerlab/e2e-throwaway/tree/main/contrib/k8s) is a kustomize base. It contains a Namespace with the *restricted* Pod Security Standard, a Deployment, a Service, a NetworkPolicy, and a ConfigMap generated from `config.yaml`.

```sh
kubectl apply -k contrib/k8s                       # directly
```

With Flux, point an overlay in the cluster repo at a release:

```yaml
# kustomization.yaml in the GitOps repo
resources:
  - https://github.com/metalayerlab/e2e-throwaway//contrib/k8s?ref=v1.2.3
patches: []          # replicas, resources, the ConfigMap's config.yaml, ingress
```

The NetworkPolicy admits only the `traefik` namespace: add each in-cluster client. State is on an `emptyDir`; swap it for a PersistentVolumeClaim if it must survive a restart. Secrets: SOPS-encrypted Secrets in the GitOps repo, mounted as files.

## systemd

```sh
install -Dm644 contrib/systemd/e2e-throwaway.sysusers /usr/lib/sysusers.d/e2e-throwaway.conf
systemd-sysusers
UV_PYTHON_INSTALL_DIR=/opt/uv-python uv venv /opt/e2e-throwaway
uv pip install --python /opt/e2e-throwaway git+https://github.com/metalayerlab/e2e-throwaway@v1.2.3
install -Dm644 contrib/e2e-throwaway.example.yaml /etc/e2e-throwaway/config.yaml   # edit it
install -Dm644 contrib/systemd/e2e-throwaway.service /etc/systemd/system/
systemctl daemon-reload && systemctl enable --now e2e-throwaway
journalctl -u e2e-throwaway -f
```

The unit runs as the `e2e-throwaway` system user in a tight sandbox (`systemd-analyze security e2e-throwaway` scores it). If a feature needs more access, loosen exactly one directive, with a comment saying why.

## Upgrading

Read the [CHANGELOG](https://github.com/metalayerlab/e2e-throwaway/blob/main/CHANGELOG.md) entries between your version and the new one; breaking changes are marked ⚠. Then:

- Compose: change the image tag, then `docker compose up -d`.
- Kubernetes: change `?ref=` (or the `images:` tag) in the overlay, and let Flux reconcile.
- systemd: `uv pip install --python /opt/e2e-throwaway git+https://github.com/metalayerlab/e2e-throwaway@vX.Y.Z`, then `systemctl restart e2e-throwaway`.

There are no data migrations: the service keeps no persistent state yet, so `state_dir` can be left alone on upgrade. Settings are only added, so existing config files keep working unless the CHANGELOG says otherwise. To roll back, deploy the previous image tag, `?ref=` or version with the same steps as an upgrade.
