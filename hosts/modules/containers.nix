{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.x;
in
{
  options.x = {
    enable = mkEnableOption "Containerization support";

    engine = mkOption {
      type = types.enum [ 
        "docker"
        "podman"
        # lxc?
        # nix x?
      ];

      default = "docker";
      description = "Select which containerization engine to use.";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.${cfg.engine} = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
