{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.gpg;
in
{
  options.gpg = {
    enable = mkEnableOption "GPG support";
  };

  config = mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";

      mutableKeys = true;
      mutableTrust = true;

      publicKeys = [
        {
          source = ./gpg-pubkey.asc;
          trust = "ultimate";
        }
      ];
    };

    home.packages = with pkgs; [
      pinentry-curses
    ];

    services.gpg-agent = {
      enable = true;

      enableSshSupport = true;
      enableScDaemon = true;

      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;

      pinentry.package = pkgs.pinentry-curses;

      # would like to setup gpg+ssh keys to have consistent, root identity keys
      sshKeys = [
        "2F148DA70CCEBC6860C7653A79983EE9493ADBC9"
      ];
    };
  };
}
