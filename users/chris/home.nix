{ pkgs, user, ... }:
  import ./packages.nix { inherit pkgs user; }
// {
  shells.enable = "bash";
}
