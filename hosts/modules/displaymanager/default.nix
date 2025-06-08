{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.displaymanager;
in
{
  imports = [
    ./sddm.nix
    ./gdm.nix
    ./lightdm.nix
  ];

  options.displaymanager = {
    enable = mkOption {
      description = "Display manager to use";
      type = with types; nullOr (enum []);
      default = null;
    };
  };
}
