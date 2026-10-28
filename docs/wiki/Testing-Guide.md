# Testing Guide

## Running the tests

```sh
uv run pytest                                   # unit tests, with an 80% coverage floor
uv run pytest tests/unit/test_config.py -k env  # a subset
RUN_INTEGRATION=1 uv run pytest -m integration  # integration tests (real external systems)
```

CI runs the unit tests on every supported Python version, together with ruff, mypy (strict), the wiki checks and the manifest checks. All of them block a merge.

## Test layout

| Path | What goes there |
|---|---|
| `tests/unit/` | Fast and offline: no network, no real external systems. Most tests. |
| `tests/integration/` | Real dependencies, marked `@pytest.mark.integration`; skipped unless `RUN_INTEGRATION=1` |
| `tests/conftest.py` | Shared fixtures: `clean_env` (no `E2E_THROWAWAY_*` leakage), `write_config` |

The API tests use FastAPI's `TestClient` against `create_app(config)`, and `tests/unit/` has one module per source module (`test_api.py`, `test_cli.py`, `test_config.py`, `test_version.py`). There is no test data directory and no integration test yet.

## Writing tests

- Every behaviour change needs a test that fails without it. A bug fix starts with the failing test.
- Assert outcomes (outputs, side effects, errors), not internal calls.
- Use placeholders for anything that looks real: `example.org`, `192.0.2.0/24`, fake tokens.
- Don't lower the coverage floor or skip a test to make CI pass.

There are no external systems to fake. For configuration, pass a dict as `environ` to `load_config` or use `write_config` with a file path; for the API, build the app from a `Config` and call it through `TestClient`. Time and the filesystem are not used by the code yet.
