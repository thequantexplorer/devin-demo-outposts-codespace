#!/usr/bin/env bash
# Runs once when the Codespace is created. Installs the tools this repo needs
# and the Devin CLI, which provides the Outposts worker.
set -euo pipefail
cd "$(dirname "$0")/.."

TYPST_VERSION="$(cat .typst-version)"
ARCH="$(uname -m)"
echo "Installing Typst ${TYPST_VERSION}..."
curl -fsSL "https://github.com/typst/typst/releases/download/v${TYPST_VERSION}/typst-${ARCH}-unknown-linux-musl.tar.xz" \
  | sudo tar -xJ -C /usr/local/bin --strip-components=1 "typst-${ARCH}-unknown-linux-musl/typst"
typst --version

echo "Installing Python test tools..."
pip install --disable-pip-version-check --no-warn-script-location -q -r requirements-dev.txt

echo "Installing the Devin CLI..."
# The installer ends by offering to log in. The worker uses the Outpost token
# instead, so skip that step.
curl -fsSL https://cli.devin.ai/install.sh -o /tmp/devin-install.sh
bash /tmp/devin-install.sh </dev/null || true
"$HOME/.local/bin/devin" --version

echo "Setup done. Start the worker with: bash scripts/start-worker.sh"
