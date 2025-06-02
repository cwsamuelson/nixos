{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user;
in
{
  options.user = {
    username = mkOption {
      type = types.string;
      description = "User's username.";
    };

    name = mkOption {
      type = types.string;
      default = "";
      description = "User's given name.";
    };

    groups = mkOption {
      type = types.listOf types.string;
      default = [];
      description = "";
    };

    uid = mkOption {
      type = types.ints.unsigned;
      default = 1000;
      description = "User uid";
    };

    gid = mkOption {
      type = types.ints.unsigned;
      default = 1000;
      description = "User's group gid";
    };
  };

  config = {
    users.users.${cfg.username} = {
      isNormalUser = true;
      uid = cfg.uid;
      #primaryGroup = "chris";
      description = cfg.name;
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ] ++ cfg.groups;
      packages = with pkgs; [
        home-manager
      ];
    };

    users.groups.${cfg.username} = {
      gid = cfg.gid;
    };

    services.displayManager.autoLogin = {
      enable = true;
      user = cfg.username;
    };
  };
}
