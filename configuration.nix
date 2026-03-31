{ pkgs, ... }: {
  # Universal Hardware Support
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" "nvme" "usb_storage" ];
  hardware.enableAllFirmware = true;

  # Auto-rebuild on boot: Checks GitHub for changes
  system.autoUpgrade = {
    enable = true;
    flake = "github:your-user/my-secure-nixos";
    flags = [ "--update-input" "nixpkgs" ];
    dates = "reboot"; 
  };

  # Basic Setup
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true; # Change to KDE if you prefer!

  system.stateVersion = "23.11";
}
