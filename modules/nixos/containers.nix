{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.cntnr;
in
{
  options.cntnr = {
    enable = mkEnableOption "Containerization support";

    engine = mkOption {
      type = types.enum [ 
        "docker"
        "podman"
        # lxc?
        # nix containers?
      ];

      default = "docker";
      description = "Select which containerization engine to use.";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.${cfg.engine} = {
      enable = true;
      rootless = {
        # enable = true;
        setSocketVariable = true;
      };
    };
  };
}
