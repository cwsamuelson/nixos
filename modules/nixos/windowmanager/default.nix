{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.desktopmanager;
in
{
  imports = [
    ./herbstluftwm.nix
    ./i3.nix
    ./icewm.nix
    ./twm.nix
    ./xmonad.nix
  ];

  options.windowmanager = {
    enable = mkOption {
      description = "Window manager to use";
      type = with types; nullOr (enum []);
      default = null;
    };
  };
}
