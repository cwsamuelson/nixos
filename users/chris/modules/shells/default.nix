{ config, lib, pkgs, ... }:
with lib;
let
  prop = "shells";
  cfg = config.${prop};
in
{
  imports = [
    ./bash
    ./nushell.nix
    ./zsh.nix
  ];

  config.home = {
    shell.enableShellIntegration = true;
    sessionVariables = {
      CDPATH = "$HOME/projects/:$HOME/repos";
    };
  };

  options.${prop} = {
    #!@TODO enable vs default
    enable = mkOption {
      description = "";
      type = with types; nullOr (enum []);
      default = null;
    };
  };
}
