#!/usr/bin/env bash
set -euo pipefail

if command -v codium &>/dev/null; then
  echo "VSCodium already installed, skipping"
  exit 0
fi

echo "Installing VSCodium..."
sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg

printf '[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h\n' \
  | sudo tee /etc/yum.repos.d/vscodium.repo

sudo dnf install -y codium
