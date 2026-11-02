#!/usr/bin/env bash
# Turns this Codespace into a worker for your Devin Outpost.
# Leave it running. Press Ctrl+C to stop it.
set -euo pipefail

OUTPOST="${DEVIN_OUTPOST_NAME:-codespace}"
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPO_NAME="${GITHUB_REPOSITORY:-}"
REPO_NAME="${REPO_NAME##*/}"
REPO_NAME="${REPO_NAME:-$(basename "$REPO_DIR")}"
DEVIN="$(command -v devin || echo "$HOME/.local/bin/devin")"

if [ -z "${DEVIN_OUTPOSTS_TOKEN:-}" ]; then
  echo "DEVIN_OUTPOSTS_TOKEN is not set in this Codespace."
  echo "Add it at https://github.com/settings/codespaces (Codespaces secrets),"
  echo "give it access to this repository, then stop and restart the Codespace."
  exit 1
fi

# The worker gives each session the repos under ./repos of the folder it runs
# in. Link this checkout there, so Devin edits the same files you see here.
WORKER_DIR="$HOME/outpost"
mkdir -p "$WORKER_DIR/repos"
ln -sfn "$REPO_DIR" "$WORKER_DIR/repos/$REPO_NAME"
cd "$WORKER_DIR"

echo "Starting the Devin worker for outpost '$OUTPOST'."
echo "Sessions will use $WORKER_DIR/repos/$REPO_NAME -> $REPO_DIR"
"$DEVIN" worker start --outpost="$OUTPOST"
