{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.desktopmanager;
  name = "gnome";
in
{
  options.desktopmanager = {
    enable = mkOption {
      type = with types; nullOr (enum [ name ]);
    };
  };

  config = mkIf (cfg.enable == name) {
    services.xserver.desktopManager.gnome.enable = true;
  };
}
