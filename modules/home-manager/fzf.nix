{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.fzf;
in
{
  options.fzf = {
    enable = mkEnableOption "FZF support";
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      #enableNushellIntegration = true;

      defaultCommand = "fd --type f";
    };
  };
}
