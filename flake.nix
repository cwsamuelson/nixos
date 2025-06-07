# https://ayats.org/blog/no-flake-utils
{
  description = "Basic flake for configuration of my NixOS and Home Manager environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    #nixgl.url = "github:nix-community/nixGL";
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    #users = [
    #  { username = "chris"; stateVersion = "25.05"; }
    #];
    username = "chris";
    stateVersion = "25.05";
    hosts = [
      { hostname = "wsl"; stateVersion = "25.05"; }
      { hostname = "laptop-ava"; stateVersion = "25.05"; }
      { hostname = "laptop-fw"; stateVersion = "25.05"; }
    ];

    makeSystem = { hostname, stateVersion, ... }: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs stateVersion hostname username nixos-wsl;
      };

      modules = [
        ./hosts/modules
        ./hosts/base
        ./hosts/${hostname}/configuration.nix
      ];
    };

    makeHM = { username, stateVersion }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      extraSpecialArgs = {
        inherit inputs stateVersion username system;
      };

      modules = [
        ./users/${username}/home.nix
      ];
    };
  in {
    nixosConfigurations = nixpkgs.lib.foldl' (configs: host:
      configs // {
        "${host.hostname}" = makeSystem {
          inherit (host) hostname stateVersion;
        };
      }) {} hosts;

    homeConfigurations.chris = makeHM {
      inherit username stateVersion;
    };

    #homeConfigurations = nixpkgs.lib.foldl' (configs: user:
    #  configs // {
    #    "${user.username}" = makeHM {
    #      inherit (user) username stateVersion;
    #    };
    #  }) {} users;
  };
}
