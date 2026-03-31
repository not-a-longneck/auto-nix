#!/usr/bin/env bash
set -e

echo "🚀 Starting One-Click Privacy NixOS Installation..."

# 1. Auto-detect the primary disk
DISK=$(lsblk -dpno NAME,TYPE,TRAN | awk '$2=="disk" && $3!="usb" {print $1; exit}')

if [ -z "$DISK" ]; then
  echo "❌ Could not auto-detect a disk. Please set DISK manually."
  exit 1
fi
echo "💽 Detected disk: $DISK"

# 2. Download the configuration locally
echo "📥 Downloading configuration from GitHub..."
cd /tmp
rm -rf auto-nix
# The NixOS USB already has git installed!
git clone https://github.com/not-a-longneck/auto-nix.git
cd auto-nix

# 3. Patch the disk dynamically
echo "🔧 Adapting configuration for $DISK..."
# This finds "/dev/vda" in your file and replaces it with the real disk
sed -i "s|/dev/vda|$DISK|g" disko-config.nix

# 4. Partition and Install using the LOCAL files (Notice the .# instead of the GitHub URL)
echo "💾 Partitioning disks..."
sudo nix --extra-experimental-features "nix-command flakes" \
  run github:nix-community/disko -- \
  --mode disko \
  --flake .#secure-laptop

echo "🏗️ Installing NixOS..."
sudo nixos-install --flake .#secure-laptop --no-root-passwd

echo "✅ Done! Rebooting in 5 seconds..."
sleep 5
sudo reboot
