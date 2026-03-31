#!/usr/bin/env bash
set -e

# --- CONFIGURATION ---
# The GitHub Flake to use
FLAKE="github:not-a-teletubby/auto-nix#secure-laptop"

echo "🚀 Starting One-Click Privacy NixOS Installation..."

# 1. Partition and Format the Disk using Disko
# This reads your 30% System / 70% Encrypted Swap layout
echo "💾 Partitioning disks..."
sudo nix --extra-experimental-features "nix-command flakes" \
  run github:nix-community/disko -- \
  --mode disko \
  --flake "$FLAKE"

# 2. Install the NixOS System
echo "🏗️ Installing NixOS (this may take a few minutes)..."
sudo nixos-install --flake "$FLAKE" --no-root-passwd

echo "✅ Installation complete! Rebooting in 5 seconds..."
sleep 5
sudo reboot
