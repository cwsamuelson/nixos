{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.desktopmanager;
  name = "xfce";
in
{
  options.desktopmanager = {
    enable = mkOption {
      type = with types; nullOr (enum [ name ]);
    };
  };

  config = mkIf (cfg.enable == name) {
    services.xserver.desktopManager.xfce.enable = true;
  };
}
