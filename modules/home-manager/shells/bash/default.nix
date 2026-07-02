{ config, lib, pkgs, dotscripts, ... }:
with lib;
let
  prop = "shells";
  cfg = config.${prop};
  name = "bash";

  dotscripts = import ./dotfiles { inherit pkgs; };
in
{
  options.${prop} = {
    enable = mkOption {
      type = with types; nullOr (enum [ name ]);
    };
  };

  config = mkIf (cfg.enable == name) {
    programs.bash = {
      enable = true;

      enableCompletion = true;
   
      historyControl = [
        "ignorespace"
        "ignoredups"
        "erasedups"
      ];

      historyIgnore = [
        "fg"
        "fg *"
        "* --help"
        "incognito"
        "echo *"
      ];

      shellOptions = [
        "-histappend"
        "histverify"
        "autocd"
        "checkjobs"
        "checkwinsize"
        "extglob"
        "globstar"
        "cdspell"
      ];

      # manual additions to bash_profile
      profileExtra = ''
        source ${dotscripts}/bin/init.bash
      '';

      # manual additions to bashrc
      initExtra = ''
        source ${dotscripts}/bin/init.bash
      '';
    };
  };
}
