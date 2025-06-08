{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.desktopmanager;
  name = "plasma5";
in
{
  options.desktopmanager = {
    enable = mkOption {
      type = with types; nullOr (enum [ name ]);
    };
  };

  config = mkIf (cfg.enable == name) {
    services.xserver.desktopManager.plasma5.enable = true;
  };
}
