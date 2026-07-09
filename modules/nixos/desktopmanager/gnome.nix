{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.desktopmanager;
  name = "gnome";
in
{
  options.desktopmanager = {
    # Can't use mkEnableOption for now, since the desktopmanager option works a little differently
    # enable = mkEnableOption "Use gnome desktop manager.";
    enable = mkOption {
      type = with types; nullOr (enum [ name ]);
    };

    autologin = mkOption {
      type = types.bool;
      default = true;
      description = "Enable autologin.";
    };
  };

  config = mkIf (cfg.enable == name) {
    services.desktopManager.${name}.enable = true;

    # Set default session for display manager (required for autologin)
    services.displayManager.defaultSession = "gnome";

    # Workaround for GNOME autologin:
    #   https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd = mkIf cfg.autologin {
      services = {
        "getty@tty1".enable = false;
        "autovt@tty1".enable = false;
      };
    };

    # services = {
    #   xserver = {
    #     desktopManager.gnome.enable = true;
    #     displayManager.gdm.enable = true;
    #   };
    # };
  };
}
