#!/usr/bin/env bash
set -euo pipefail

if command -v docker &>/dev/null; then
  echo "Docker already installed, skipping"
  exit 0
fi

echo "Installing Docker CE..."
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
echo "Docker installed. Log out and back in for group changes to take effect."
