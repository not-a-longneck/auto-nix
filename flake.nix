{
  description = "Privacy Fortress - Stateless NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, disko, home-manager, plasma-manager, ... }: {
    nixosConfigurations.secure-laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import the Disko module for partitioning logic
        disko.nixosModules.disko
        
        # Import your main system configuration
        ./configuration.nix

        # Import Home Manager module
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          
          # This block maps your home.nix and the plasma-manager to the 'admin' user
          home-manager.users.admin = {
            imports = [
              ./home.nix
              plasma-manager.homeManagerModules.plasma-manager
            ];
          };
        }
      ];
    };
  };
}
