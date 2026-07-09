{ config, lib, pkgs, user, ... }:
let
  cfg = config.user;
  # Only enable autologin if a desktop manager is actually configured
  hasDesktopManager = config.desktopmanager.enable != null;
in
{
  config = {
    # Set user config from specialArgs
    user = {
      inherit (user) name email groups;
    };

    users = {
      users.${cfg.username} = {
        isNormalUser = true;
        uid = cfg.uid;
        #primaryGroup = "chris";
        description = cfg.name;
        extraGroups = cfg.groups;
        packages = with pkgs; [
          home-manager
        ];
      };

      groups.${cfg.username} = {
        gid = cfg.gid;
      };
    };

    services.displayManager.autoLogin = lib.mkIf hasDesktopManager {
      enable = true;
      user = cfg.username;
    };
  };
}
