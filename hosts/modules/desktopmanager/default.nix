{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.desktopmanager;
in
{
  imports = [
    ./plasma5.nix
    ./xfce.nix
    ./gnome.nix
    ./mate.nix
  ];

  options.desktopmanager = {
    enable = mkOption {
      description = "Desktop manager to use";
      type = with types; nullOr (enum []);
      default = null;
    };
  };
}
