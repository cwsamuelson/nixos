{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nys;
in
{
  options.tmux = {
    enable = mkEnableOption "TMUX configuration";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;

      clock24 = true;
      # on qwerty or standard dvorak, 1 is more convenient than 0
      baseIndex = 1;
      focusEvents = true;
      keyMode = "vi";
      mouse = true;
      newSession = true;
      #plugins = [
      #];
      # good one to override based on what shell is chosen
      # might mean changing it in the <shell>.nix modules
      #shell = "...";
    };
  };
}