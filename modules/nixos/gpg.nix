{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.gpg;
in
{
  options.gpg = {
    enable = mkEnableOption "GPG configuration";
  };

  config = mkIf cfg.enable {
    services = {
      # yubikey features..
      pcscd.enable = true;
      udev.packages = with pkgs; [
        yubikey-personalization
      ];
    };
  };
}

