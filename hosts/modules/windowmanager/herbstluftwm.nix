{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.windowmanager;
  name = "herbstluftwm";
in
{
  options.windowmanager = {
    enable = mkOption {
      type = with types; nullOr (enum [ name ]);
    };
  };

  config = mkIf (cfg.enable == name) {
    services.xserver.windowManager.herbstluftwm.enable = true;
  };
}
