{ config, lib, gui, ... }:
with lib;
let
  cfg = config.gui;
in
{
  options.gui = {
    enable = mkEnableOption "GUI configuration";
  };

  config = mkIf cfg.enable {
    desktopmanager.enable = "gnome";
    displaymanager.enable = "gdm";
    #desktopManager.gnome.enable = true;
    #displayManager.gdm.enable = true;
  };
}

