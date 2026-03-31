{ device ? "/dev/vda", lib, ... }: { 
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "size=80%" "mode=755" ];
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
           # Use a fixed size for the System (Nix Store)
           # 50GB is plenty for apps/drivers on a privacy machine
           nixos = {
             size = "15G"; 
             content = {
               type = "filesystem";
               format = "ext4";
               mountpoint = "/nix"; 
             };
           };
           # Let the Swap take 100% of the remaining space
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
