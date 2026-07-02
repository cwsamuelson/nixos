{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nys;
in
{
  options.nys = {
    enable = mkEnableOption "Nix Your Shell configuration";
  };

  config = mkIf cfg.enable {
    programs.nix-your-shell = {
      enable = true;
    };
  };
}
