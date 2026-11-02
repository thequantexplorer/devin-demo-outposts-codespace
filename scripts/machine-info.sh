#!/usr/bin/env bash
# Prints which machine this is, so you can tell a Codespace from any other.
echo "machine:   ${CODESPACE_NAME:-$(hostname)}"
echo "codespace: ${CODESPACES:-false}"
echo "repo:      ${GITHUB_REPOSITORY:-unknown}"
echo "typst:     $(typst --version 2>/dev/null || echo 'not installed')"
echo "python:    $(python3 --version 2>&1)"
