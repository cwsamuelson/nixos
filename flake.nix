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
    user = {
      username = "chris";
      name = "Chris Samuelson";
      stateVersion = "25.05";
    };
    hosts = [
      { hostname = "wsl"; stateVersion = "25.05"; }
      { hostname = "laptop-ava"; stateVersion = "25.05"; }
      { hostname = "laptop-fw"; stateVersion = "25.05"; }
    ];

    makeSystem = { host, ... }: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs host user nixos-wsl;
      };

      modules = [
        ./hosts/modules
        ./hosts/base
        ./hosts/${host.hostname}/configuration.nix
      ];
    };

    makeHM = { user }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      extraSpecialArgs = {
        inherit inputs user system;
      };

      modules = [
        ./users/${user.username}/home.nix
      ];
    };
  in {
    nixosConfigurations = nixpkgs.lib.foldl' (configs: host:
      configs // {
        "${host.hostname}" = makeSystem {
          inherit host;
        };
      }) {} hosts;

    homeConfigurations.chris = makeHM {
      inherit user;
    };

    #homeConfigurations = nixpkgs.lib.foldl' (configs: user:
    #  configs // {
    #    "${user.username}" = makeHM {
    #      inherit (user) username stateVersion;
    #    };
    #  }) {} users;
  };
}
