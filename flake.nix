# https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager
# https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-with-flakes-enabled
# https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-configuration-explained

{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations.chris-laptop-ava = nixpkgs.lib.nixosSystem {
      system = "x86_64-Linux";

      specialArgs = attrs;
      modules = [
        ./configuration.nix
      ];
    };
  };
}
