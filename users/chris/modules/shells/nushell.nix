{ config, lib, pkgs, dotscripts, ... }:
with lib;
let
  prop = "shells";
  cfg = config.${prop};
  name = "nushell";
in
{
  options.${prop} = {
    enable = mkOption {
      type = with types; nullOr (enum [ name ]);
    };
  };

  config = mkIf (cfg.enable == name) {
    #home.shell.enableNushellIntegration = true;

    programs.nushell = {
      enable = true;
    };
  };
}
