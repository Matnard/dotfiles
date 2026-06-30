#!/usr/bin/env bash
# Full machine setup from dotfiles.
# Usage: bash setup.sh
#
# On a new machine:
#   git clone <your-repo-url> ~/.dotfiles
#   bash ~/.dotfiles/setup.sh

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

detect_distro() {
  if [ -f /etc/os-release ]; then
    # shellcheck source=/dev/null
    . /etc/os-release
    echo "${ID:-unknown}"
  else
    echo "unknown"
  fi
}

install_arch() {
  if ! command -v yay &>/dev/null; then
    echo "Installing yay (AUR helper)..."
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay-install
    (cd /tmp/yay-install && makepkg -si --noconfirm)
    rm -rf /tmp/yay-install
  fi

  echo "Installing packages from packages/arch.txt..."
  yay -S --needed --noconfirm - < "$DOTFILES/packages/arch.txt"
}

install_fedora() {
  echo "Enabling RPM Fusion (free + nonfree)..."
  local fedora_ver
  fedora_ver=$(rpm -E %fedora)
  sudo dnf install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${fedora_ver}.noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${fedora_ver}.noarch.rpm"

  echo "Installing packages from packages/fedora.txt..."
  grep -v '^#' "$DOTFILES/packages/fedora.txt" | grep -v '^$' | \
    xargs sudo dnf install -y

  echo "Installing Golang (needed for go tools)..."
  sudo dnf install -y golang

  echo "Running extra install scripts..."
  bash "$DOTFILES/extras/install-brave-fedora.sh"
  bash "$DOTFILES/extras/install-vscodium-fedora.sh"
  bash "$DOTFILES/extras/install-docker-fedora.sh"
  bash "$DOTFILES/extras/install-flatpaks.sh"
  bash "$DOTFILES/extras/install-go-tools.sh"
}

# ── Main ────────────────────────────────────────────────────────────────────

DISTRO=$(detect_distro)
echo "Detected distro: $DISTRO"

case "$DISTRO" in
  arch|endeavouros|manjaro|cachyos|garuda)
    install_arch
    ;;
  fedora)
    install_fedora
    ;;
  *)
    echo "Distro '$DISTRO' not explicitly supported — skipping package install."
    echo "Run link.sh manually and install packages by hand."
    ;;
esac

echo ""
echo "Linking dotfiles..."
bash "$DOTFILES/link.sh"

echo ""
echo "Installing nvm..."
bash "$DOTFILES/extras/install-nvm.sh"

echo ""
echo "══════════════════════════════════════════════════════"
echo "  Setup complete. Manual steps remaining:"
echo "══════════════════════════════════════════════════════"
echo ""
echo "  SSH keys (do NOT put private keys in git):"
echo "    Copy your keys to ~/.ssh/ from your backup drive"
echo "    chmod 600 ~/.ssh/id_*"
echo "    chmod 644 ~/.ssh/*.pub"
echo ""
echo "  After NVM installs node, update the npx path in:"
echo "    ~/.config/VSCodium/User/mcp.json"
echo "    (change the hardcoded NVM node version to match)"
echo ""
echo "  Log in to:"
echo "    - Brave browser (sync)"
echo "    - Firebase CLI:    firebase login"
echo "    - gcloud CLI:      gcloud auth login"
echo "    - Supabase:        supabase login"
echo "    - Docker Hub:      docker login"
echo ""
echo "  VSCodium extensions are not synced — reinstall from:"
echo "    Extensions panel or: codium --install-extension <id>"
echo ""
echo "  Metasploit: install manually from https://docs.metasploit.com/docs/using-metasploit/getting-started/nightly-installers.html"
echo ""
