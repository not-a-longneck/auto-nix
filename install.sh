#!/usr/bin/env bash
set -e

FLAKE="github:not-a-longneck/auto-nix#secure-laptop"

echo "🚀 Starting One-Click Privacy NixOS Installation..."

# Auto-detect the primary disk (picks the first non-USB, non-loop disk)
DISK=$(lsblk -dpno NAME,TYPE,TRAN | awk '$2=="disk" && $3!="usb" {print $1; exit}')

if [ -z "$DISK" ]; then
  echo "❌ Could not auto-detect a disk. Please set DISK manually."
  exit 1
fi

echo "💽 Detected disk: $DISK"
echo "💾 Partitioning disks..."

# The magic line that passes the detected disk to the Nix code
sudo nix --extra-experimental-features "nix-command flakes" \
  run github:nix-community/disko -- \
  --mode disko \
  --flake "$FLAKE" \
  --argstr device "$DISK" # Use --argstr for cleaner passing of strings

echo "🏗️ Installing NixOS..."
sudo nixos-install --flake "$FLAKE" --no-root-passwd

echo "✅ Done! Rebooting in 5 seconds..."
sleep 5
sudo reboot
