#!/usr/bin/env bash
# Symlinks dotfiles into place. Safe to re-run — backs up existing files first.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  backing up $dst -> $dst.bak"
    mv "$dst" "$dst.bak"
  fi

  ln -sf "$src" "$dst"
  echo "  linked $dst"
}

echo "Linking dotfiles..."

link "$DOTFILES/home/.bashrc"                        "$HOME/.bashrc"
link "$DOTFILES/home/.bash_profile"                  "$HOME/.bash_profile"
link "$DOTFILES/home/.aliases"                       "$HOME/.aliases"
link "$DOTFILES/home/.gitconfig"                     "$HOME/.gitconfig"
link "$DOTFILES/home/.inputrc"                       "$HOME/.inputrc"
link "$DOTFILES/home/.mcp.json"                      "$HOME/.mcp.json"
link "$DOTFILES/config/htop/htoprc"                  "$HOME/.config/htop/htoprc"
link "$DOTFILES/config/VSCodium/User/settings.json"  "$HOME/.config/VSCodium/User/settings.json"

echo "Done."
