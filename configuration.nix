{ pkgs, ... }: {
  
  =============================
  ==== Hardware & Firmware ====
  =============================

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" "nvme" "usb_storage" ];
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  # Storage Optimization (The "Tails" Buffer)
  # This allows /tmp to use up to 90% of available RAM + Swap 
  # Perfect for those 20GB+ downloads.
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "90%"; 

  # Auto-rebuild on boot
  system.autoUpgrade = {
    enable = true;
    flake = "github:not-a-longneck/auto-nix";
    flags = [ "--update-input" "nixpkgs" ];
    dates = "reboot"; 
  };

  =============================
  ==== Apps and tools      ====
  =============================

  environment.systemPackages = with pkgs; [
    tor-browser
    firefox
    vlc
    veracrypt
    pyload-ng
    sunshine
    
    
  ];
  
  services.tor.enable = true;
  services.tor.client.enable = true;

  # 5. Desktop Environment (GNOME)
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # 6. User Setup

# Define your personal user
  users.users.admin = {
    isNormalUser = true;
    description = "Privacy User";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    # This password will be active every time you boot
    hashedPassword = "$6$Osqk1/PTMVPFxz.R$xnhXNz5ePRgPQZtGMaXlSDInDsrwNocuRqVmTfZcq4ujAer6PiesG27vZpkxdMJh3gtSzP9qOlTs8CTP9Pf.f/"; 
  };

  # Disable Guest/Auto-login for Security
  services.displayManager.autoLogin.enable = false;
  services.xserver.displayManager.gdm.wayland = true; # Modern & Secure
  system.stateVersion = "23.11";
}
