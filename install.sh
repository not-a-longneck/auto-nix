#!/usr/bin/env bash
set -e

echo "🚀 Starting One-Click Privacy NixOS Installation..."

# 1. Display available disks so you can see what is what
echo "------------------------------------------------------------"
echo "IDENTIFIED DISKS:"
# This shows Name, Size, Model, and Transport (USB/SATA/NVMe)
lsblk -d -n -o NAME,SIZE,MODEL,TRAN | grep -v "loop"
echo "------------------------------------------------------------"

# 2. Ask for manual selection
read -p "👉 Enter the disk NAME to format (e.g., vda, sda): " USER_CHOICE

# Clean up the input (remove /dev/ if the user typed it)
DISK_NAME=$(echo "$USER_CHOICE" | sed 's|^/dev/||')
DISK="/dev/$DISK_NAME"

# 3. Validation: Does the disk actually exist?
if [ ! -b "$DISK" ]; then
  echo "❌ Error: $DISK is not a valid block device. Please check the name and try again."
  exit 1
fi

# 4. The "Point of No Return" Confirmation
echo ""
echo "⚠️  WARNING: EVERYTHING ON $DISK WILL BE PERMANENTLY DELETED!"
echo "This includes any VeraCrypt volumes or existing data."
read -p "Type 'CONFIRM' to proceed with wiping $DISK: " FINAL_CHECK

if [ "$FINAL_CHECK" != "CONFIRM" ]; then
  echo "❌ Installation aborted. No changes were made."
  exit 1
fi

echo "💽 Targeted disk: $DISK"

# 5. Download the configuration locally
echo "📥 Downloading configuration from GitHub..."
cd /tmp
rm -rf auto-nix
git clone https://github.com/not-a-longneck/auto-nix.git
cd auto-nix

# 6. Patch the disk dynamically
echo "🔧 Adapting configuration for $DISK..."
# We use a more robust sed to replace whatever was in the device line
sed -i "s|device = \".*\";|device = \"$DISK\";|g" disko-config.nix

# 7. Partition and Install
echo "💾 Partitioning disks..."
sudo nix --extra-experimental-features "nix-command flakes" \
  run github:nix-community/disko -- \
  --mode disko \
  --flake .#secure-laptop

echo "🏗️  Installing NixOS..."
# We use --no-root-passwd as per your request, assuming you set your user password in the config
sudo nixos-install --flake .#secure-laptop --no-root-passwd

echo "✅ Done! Rebooting in 5 seconds..."
sleep 5
sudo reboot
