{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.direnv;
in
{
  options.direnv = {
    enable = mkEnableOption "Direnv support";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;

      nix-direnv.enable = true;
    };
  };
}