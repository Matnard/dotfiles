#!/usr/bin/env bash
set -euo pipefail

if ! command -v go &>/dev/null; then
  echo "go not found — install golang first (sudo dnf install golang on Fedora)"
  exit 1
fi

echo "Installing Go-based tools..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
echo "subfinder installed to $(go env GOPATH)/bin/subfinder"
