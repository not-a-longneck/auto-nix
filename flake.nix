{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # 1. Add this input
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, home-manager, ... }: {
    nixosConfigurations.secure-laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # 2. Add the Disko module here!
        disko.nixosModules.disko
        
        ./configuration.nix
        # (Assuming disko-config is imported inside your configuration.nix)
        
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.admin = import ./home.nix;
        }
      ];
    };
  };
}
