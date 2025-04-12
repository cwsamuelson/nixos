
#packages.x86_64-linux.nixosConfigurations."wsl".config.system.build.nixos-rebuild
#legacyPackages.x86_64-linux.nixosConfigurations."wsl".config.system.build.nixos-rebuild
#nixosConfigurations."wsl".config.system.build.nixos-rebuild
{
  description = "";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    #flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }:
    let
      system = "x86_64-linux";
      #pkgs = import nixpkgs { inherit system; };
    in {
      # Define your NixOS configurations by hostname
      nixosConfigurations = {
        wsl = nixpkgs.lib.nixosSystem {
          system = system;

          # pull in custom configuration files.
          modules = [
	    nixos-wsl.nixosModules.wsl
            ./configuration.nix
          ];

          # Pass additional inputs to configuration.
          specialArgs = {
            inherit system;
            # Making other inputs available for deeper configuration files
            inputs = {
              nixpkgs = nixpkgs;
              home-manager = home-manager;
            };
          };
        };
      };
    };
}

