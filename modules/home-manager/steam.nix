{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.steam;
in
{
  options.steam = {
    enable = mkEnableOption "Enable steam";
  };

  config = mkIf cfg.enable {
    # https://github.com/SteamNix/SteamNix/blob/main/configuration.nix
    # https://nixos.wiki/wiki/Steam
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
