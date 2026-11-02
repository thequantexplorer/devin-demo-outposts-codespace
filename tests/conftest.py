import shutil

import pytest


def pytest_sessionstart(session):
    if shutil.which("typst") is None:
        pytest.exit(
            "typst is not installed on this machine. These tests run in this "
            "repo's Codespace, where .devcontainer/setup.sh installs it.",
            returncode=1,
        )
