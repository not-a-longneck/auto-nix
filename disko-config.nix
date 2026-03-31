{
  disko.devices = {
    # 1. This tells NixOS: "The main OS and User files live in RAM"
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "size=24G" "mode=755" ]; # Reserve 24GB of your 32GB RAM
    };

    disk.main = {
      device = "/dev/sda"; # We override this to /dev/nvme0n1 if needed
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "500M";
            type = "EF00";
            content = { type = "filesystem"; format = "vfat"; mountpoint = "/boot"; };
          };
          # 2. This is the 50% "System" partition for Apps/Drivers
          nixos = {
            size = "30%"; 
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix"; 
            };
          };
          # 3. This is the"Privacy" partition (Randomly Encrypted Swap)
          swap = {
            size = "100%"; 
            content = {
              type = "swap";
              randomEncryption = true; # New key every boot!
            };
          };
        };
      };
    };
  };
}
