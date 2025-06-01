# https://ayats.org/blog/no-flake-utils

{
  description = "Basic flake for configuration of my 3 NixOS environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    #init-bash.url = "path:/home/chris/wrappers/example";
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      #users = [
      #  { username = "chris"; stateVersion = "24.11"; }
      #];
      username = "chris";
      stateVersion = "24.11";
      hosts = [
        { hostname = "wsl"; stateVersion = "24.11"; }
        { hostname = "laptop-ava"; stateVersion = "24.11"; }
        { hostname = "laptop-fw"; stateVersion = "24.11"; }
      ];

      #forAllSystems = function:
      #  nixpkgs.lib.genAttrs [
      #    "x86_64-linux"
      #    "aarch64-linux"
      #  ] (system:
      #    function (import nixpkgs {
      #      inherit system;
      #      config.allowUnfree = true;
      #      overlays = [
      #        inputs.something.overlays.default
      #      ];
      #  }));

      makeSystem = { hostname, stateVersion, ... }: nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {
          inherit inputs stateVersion hostname username nixos-wsl;
        };

        modules = [
          ./baseconfig.nix
          ./hosts/${hostname}/configuration.nix
        ];
      };

      makeHM = { username, stateVersion }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        extraSpecialArgs = {
          inherit inputs stateVersion username system;
        };

        modules = [
          ./users/${username}/home.nix

          #{
          #  home.packages = [
          #    init-bash.packages.x86_64-linux.default
          #  ];
          #}
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

