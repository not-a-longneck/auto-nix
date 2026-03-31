{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, ... }: {
    nixosConfigurations.secure-laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      # THIS IS THE MISSING PIECE:
      # It tells Nix to expect a 'device' variable (defaulting to /dev/vda)
      specialArgs = { device = "/dev/vda"; }; 

      modules = [
        disko.nixosModules.disko
        ./disko-config.nix
        ./configuration.nix
      ];
    };
  };
}
