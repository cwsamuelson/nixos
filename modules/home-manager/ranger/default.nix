{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.ranger;
in
{
  options.ranger = {
    enable = mkEnableOption "Ranger configuration";
  };

  config = mkIf cfg.enable {
    programs.ranger = {
      enable = true;

      settings = {
        unicode_ellipsis = true;
        preview_images_method = "kitty";
        vcs_aware = true;
        hidden_filter = "(?:^\\.(?:git|devenv|direnv)$)|(?:.*(?:pyc|bak|swp))";
      };
    };
  };
}
