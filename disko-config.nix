{
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "size=4G" "mode=755" ];
    };
    disk.main = {
      device = "/dev/sda"; # We will override this during install if needed
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "500M";
            type = "EF00";
            content = { type = "filesystem"; format = "vfat"; mountpoint = "/boot"; };
          };
          # This is your 20GB+ storage for ISOs
          storage = {
            size = "50G";
            content = { type = "filesystem"; format = "ext4"; mountpoint = "/var/lib/downloads"; };
          };
          # Randomly encrypted swap
          swap = {
            size = "16G";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          };
        };
      };
    };
  };
}
