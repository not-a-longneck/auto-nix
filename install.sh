#!/usr/bin/env bash
set -e

echo "🚀 Starting One-Click Privacy NixOS Installation..."

# 1. Display available disks with detail
echo "------------------------------------------------------------"
echo "IDENTIFIED DISKS:"
# Displays Name, Size, Model, and Transport (checks if it's USB/SATA/NVMe)
lsblk -d -n -o NAME,SIZE,MODEL,TRAN | grep -v "loop"
echo "------------------------------------------------------------"

# 2. Ask for manual selection
read -p "👉 Enter the disk NAME to format (e.g., vda, sda): " USER_CHOICE

# Clean up input (remove /dev/ if the user typed it)
DISK_NAME=$(echo "$USER_CHOICE" | sed 's|^/dev/||')
DISK="/dev/$DISK_NAME"

# 3. Validation: Check if device exists
if [ ! -b "$DISK" ]; then
  echo "❌ Error: $DISK is not a valid block device. Please check the name."
  exit 1
fi

# 4. Interactive Safety Gate
echo ""
echo "⚠️  WARNING: EVERYTHING ON $DISK WILL BE PERMANENTLY DELETED!"
echo "This will destroy all data, including encrypted VeraCrypt volumes."
echo "Your current target is: $DISK"
read -p "Type 'CONFIRM' (all caps) to wipe this disk and proceed: " FINAL_CHECK

if [ "$FINAL_CHECK" != "CONFIRM" ]; then
  echo "❌ Installation aborted. No changes were made."
  exit 1
fi

# 5. Setup Workspace
echo "📥 Downloading configuration from GitHub..."
cd /tmp
rm -rf auto-nix
git clone https://github.com/not-a-longneck/auto-nix.git
cd auto-nix

# 6. Patch the Disko config dynamically
echo "🔧 Setting target device to $DISK..."
# This matches the specific line in your disko file: device = "/dev/vda";
sed -i "s|device = \"/dev/vda\";|device = \"$DISK\";|g" disko-config.nix

# 7. Execute Partitioning
echo "💾 Partitioning and formatting $DISK..."
sudo nix --extra-experimental-features "nix-command flakes" \
  run github:nix-community/disko -- \
  --mode disko \
  --flake .#secure-laptop

# 8. Install System
echo "🏗️  Installing NixOS to $DISK..."
sudo nixos-install --flake .#secure-laptop --no-root-passwd

echo "✅ Done! Remove the installation media and reboot."
echo "Rebooting in 5 seconds..."
sleep 5
sudo reboot
