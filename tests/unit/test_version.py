import re

import e2e_throwaway


def test_version_is_pep440() -> None:
    assert re.fullmatch(r"\d+\.\d+\.\d+.*|0\+unknown", e2e_throwaway.__version__)
