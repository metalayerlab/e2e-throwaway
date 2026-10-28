# Introduction

## What it is

e2e-throwaway is a tiny HTTP service that exists to exercise the project template end to end: configuration, CLI, API, container image, manifests and wiki. It is for the template's maintainers and for people learning its conventions. It does not do any real work beyond answering a few endpoints.

## How it works

`e2e-throwaway serve` loads the configuration (environment, files, defaults), builds the FastAPI app and runs it under uvicorn. Clients call `/healthz`, `/readyz`, `/version` or `/hello` and get small JSON answers. Internals are in [Architecture Internals](Architecture-Internals).

## When not to use it

Do not use it for production workloads: it has no authentication, no persistent state and no real functionality. Start from the template instead when you need a new service.
