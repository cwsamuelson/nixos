{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.todoman;
in
{
  options.todoman = {
    enable = mkEnableOption "Todoman support";
  };

  config = mkIf cfg.enable {
    programs.todoman = {
      enable = true;
    };
  };
}
