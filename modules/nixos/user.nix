{ config, pkgs, ... }:
let
  cfg = config.user;
in
{
  config = {
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

    services.displayManager.autoLogin = {
      enable = true;
      user = cfg.username;
    };
  };
}
