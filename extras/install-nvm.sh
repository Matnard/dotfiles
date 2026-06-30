#!/usr/bin/env bash
set -euo pipefail

if [ -d "$HOME/.nvm" ]; then
  echo "nvm already installed, skipping"
  exit 0
fi

echo "Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install 22
nvm alias default 22
echo "nvm installed, node $(node -v)"
