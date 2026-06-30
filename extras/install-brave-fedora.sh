#!/usr/bin/env bash
set -euo pipefail

if command -v brave-browser &>/dev/null; then
  echo "Brave already installed, skipping"
  exit 0
fi

echo "Installing Brave browser..."
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo dnf install -y brave-browser
