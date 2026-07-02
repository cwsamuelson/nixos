# https://ayats.org/blog/no-flake-utils
{
  description = "Basic flake for configuration of my NixOS and Home Manager environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    #nixgl.url = "github:nix-community/nixGL";
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }@inputs:
  with nixpkgs.lib;
  let
    system = "x86_64-linux";
    user = {
      name = "Chris Samuelson";
      username = toLower (head (splitString " " user.name));
      stateVersion = "26.05";
      groups = [
        "networkmanager"
        "wheel"
        "docker"
        "dialout"
      ];
      email =  "chris.sam55@gmail.com";
    };
    hosts = [
      { hostname = "wsl"; stateVersion = "26.11"; }
      { hostname = "laptop-ava"; stateVersion = "26.11"; }
      { hostname = "laptop-fw"; stateVersion = "26.11"; }
    ];

    makeSystem = { host }: nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs host user nixos-wsl;
      };

      modules = [
        ./modules/shared
        ./modules/nixos
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
          ./modules/shared
          ./modules/home-manager
          ./users/${user.username}
        ];
      };
  in {
    nixosConfigurations = foldl' (configs: host:
      configs // {
        "${host.hostname}" = makeSystem {
          inherit host;
        };
      }) {} hosts;

    homeConfigurations.chris = makeHM {
      inherit user;
    };

    #homeConfigurations = foldl' (configs: user:
    #  configs // {
    #    "${user.username}" = makeHM {
    #      inherit (user) username stateVersion;
    #    };
    #  }) {} users;
  };
}
