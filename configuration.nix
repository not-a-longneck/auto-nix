{ pkgs, ... }: {

  imports = [
      ./disko-config.nix  # <--- ADD THIS LINE
    ];

  # =============================
  # ==== Hardware & Firmware ====
  # =============================

  # bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "video=1920x1080" ];
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" "nvme" "usb_storage" "virtio_blk" ];


  # Enable networking  
  networking.networkmanager.enable = true;
  networking.hostName = "secure-laptop";

  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  # Storage Optimization (The "Tails" Buffer)
  # This allows /tmp to use up to 90% of available RAM + Swap 
  # Perfect for those 20GB+ downloads.
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "90%"; 

  # Configure keyboard layout for X11/KDE
  console.keyMap = "dk";
  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };




  # =============================
  # ==== Apps and tools      ====
  # =============================

  environment.systemPackages = with pkgs; [
    firefox
    veracrypt
    pyload-ng
    sunshine
    
    
  ];
  
  services.tor.enable = true;
  services.tor.client.enable = true;



  # =============================
  # ====     Desktop Env     ====
  # =============================

  services.xserver.enable = true;
  # Gnome
  # services.xserver.displayManager.gdm.enable = true; 
  # services.xserver.desktopManager.gnome.enable = true;

  # KDE
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output Virtual-1 --mode 1920x1080
  '';

  environment.shellAliases = {
      nix-save = "sudo nixos-rebuild switch --refresh --flake github:not-a-longneck/auto-nix#secure-laptop --no-write-lock-file";
  };



  # =============================
  # ====   User and login    ====
  # =============================


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
