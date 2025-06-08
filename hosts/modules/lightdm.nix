{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.displaymanager;
  name = "lightdm";
in
{
  options.displaymanager = {
    enable = mkOption {
      type = with types; nullOr (enum [ name ]);
    };
  };

  config = mkIf (cfg.enable == name) {
    services.xserver.displayManager.lightdm.enable = true;
  };
}
