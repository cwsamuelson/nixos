{ config, lib, user, ... }:
with lib;
let
  cfg = config.user;
in
{
  options.user = {
    name = mkOption {
      type = types.str;
      default = user.name or "";
      description = "User's given name.";
    };

    email = mkOption {
      type = types.str;
      default = user.email or "";
      description = "User's email address.";
    };

    username = mkOption {
      type = types.str;
      default = toLower (head (splitString " " cfg.name));
      description = "User's username.";
    };

    groups = mkOption {
      type = types.listOf types.str;
      default = user.groups or [];
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
}
