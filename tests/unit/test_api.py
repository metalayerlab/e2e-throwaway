from pathlib import Path

import pytest
from fastapi.testclient import TestClient

from e2e_throwaway import __version__
from e2e_throwaway.api import create_app
from e2e_throwaway.config import load_config


@pytest.fixture
def client(tmp_path: Path) -> TestClient:
    return TestClient(create_app(load_config(tmp_path / "missing.yaml", environ={})))


def test_health(client: TestClient) -> None:
    response = client.get("/healthz")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_ready(client: TestClient) -> None:
    assert client.get("/readyz").json() == {"status": "ready"}


def test_version(client: TestClient) -> None:
    assert client.get("/version").json() == {"version": __version__}
