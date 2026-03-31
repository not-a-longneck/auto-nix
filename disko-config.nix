{ device ? "/dev/vda", ... }: { 
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "size=24G" "mode=755" ];
    };

    disk.main = {
      device = device; # Now dynamic!
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "500M";
            type = "EF00";
            content = { type = "filesystem"; format = "vfat"; mountpoint = "/boot"; };
          };
          nixos = {
            size = "30%"; 
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix"; 
            };
          };
          swap = {
            size = "100%"; 
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
