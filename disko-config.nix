{ ... }: { 
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "size=80%" "mode=755" ];
    };

    disk.main = {
      device = "/dev/vda"; # The install.sh script will dynamically change this!
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
            size = "15G"; 
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
