{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.displaymanager;
  name = "sddm";
in
{
  options.displaymanager = {
    enable = mkOption {
      type = with types; nullOr (enum [ name ]);
    };
  };

  config = mkIf (cfg.enable == name) {
    services.displayManager.sddm.enable = true;
  };
}
