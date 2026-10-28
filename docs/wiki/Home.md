# e2e-throwaway

Throwaway end-to-end test of project-template

A minimal FastAPI service with a Typer command line, used as an end-to-end test of the project template. It serves health, readiness, version and greeting endpoints, and is meant for developers who want to see the template's conventions working.

```sh
e2e-throwaway serve &
curl http://127.0.0.1:8080/hello      # {"message":"hello"}
```

## Table of Contents

**Getting started**: [Introduction](Introduction) · [Quick Start](Quick-Start)

**Using it**: [In-Depth Configuration](In-Depth-Configuration) · [CLI Reference](CLI-Reference) · [HTTP API Reference](HTTP-API-Reference) · [Deployment](Deployment)
**Help**: [Troubleshooting](Troubleshooting) · [FAQ](Frequently-Asked-Questions) · [Security](Security)

**Developers**: [Contributing](Contributing) · [Architecture Internals](Architecture-Internals) · [Testing Guide](Testing-Guide) · [Release Process](Release-Process)
