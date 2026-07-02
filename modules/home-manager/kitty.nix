{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.kitty;
in
{
  options.kitty = {
    enable = mkEnableOption "Kitty configuration";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.kitty;
      shellIntegration = {
        enableZshIntegration = true;
        enableBashIntegration = true;
        #enableNushellIntegration = true;
      };

      font = {
        name = "DejaVuSansMono";
        size = 18;
      };

      settings = {
        allow_remote_control = true;
        scrollback_lines = -1;
        hide_window_decorations = true;
        tab_bar_style = "powerline";
      };
    };
  };
}
