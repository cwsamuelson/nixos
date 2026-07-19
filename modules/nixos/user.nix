{ config, lib, pkgs, users, ... }:
let
  # Only enable autologin if a desktop manager is configured and there's exactly one user
  hasDesktopManager = config.desktopmanager.enable != null;
  hasSingleUser = (builtins.length users) == 1;
  firstUser = (builtins.head users);
in
{
  config = {
    users = {
      users =
        let
          pairs = map (user: {
            name = user.username;
            value = {
              isNormalUser = true;
              inherit (user) uid;
              description = user.name;
              extraGroups = user.groups;
              packages = with pkgs; [
                home-manager
              ];
            };
          }) users;
        in
        builtins.listToAttrs pairs;

      groups =
        let
          pairs = map (user: {
            name = user.username;
            value.gid = user.gid;
          }) users;
        in
        builtins.listToAttrs pairs;
    };

    services.displayManager.autoLogin = lib.mkIf (hasDesktopManager && hasSingleUser) {
      enable = true;
      user = firstUser.username;
    };
  };
}
