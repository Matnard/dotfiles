#!/usr/bin/env bash
# Postman, Bruno, Zen browser, RustDesk — no good native Fedora package

set -euo pipefail

if ! command -v flatpak &>/dev/null; then
  sudo dnf install -y flatpak
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
fi

FLATPAKS=(
  "com.getpostman.Postman"
  "com.usebruno.Bruno"
  "io.gitlab.zen_browser.zen"
  "com.rustdesk.RustDesk"
)

for app in "${FLATPAKS[@]}"; do
  if flatpak list | grep -q "$app"; then
    echo "$app already installed, skipping"
  else
    flatpak install -y flathub "$app"
  fi
done
