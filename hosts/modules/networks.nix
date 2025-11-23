{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.networks;

  servicePortMap = {
    localsend = {
      tcp = [ 53317 ];
      udp = [ 53317 ];
    };

    uxplay = {
      tcp = [ 7000 7001 ];
      udp = [ 5353 ];
    };
  };

  tcpPorts = concatLists (map
    (s: servicePortMap.${s}.tcp)
    cfg.firewall.activeServices
  );
  udpPorts = concatLists (map
    (s: servicePortMap.${s}.udp)
    cfg.firewall.activeServices
  );
in
{
  options.networks = {
    hostname = mkOption {
      type = types.str;

      description = "";
    };

    firewall = {
      enable = mkEnableOption "";

      openTCPPorts = mkOption {
        type = types.listOf types.port;
        default = [];
        description = "";
      };

      openUDPPorts = mkOption {
        type = types.listOf types.port;
        default = [];
        description = "";
      };

      activeServices = mkOption {
        type = types.listOf (types.enum
          (attrNames servicePortMap)
        );

        description = "";
      };
    };
  };

  config = {
    networking = {
      networkmanager.enable = true;

      hostName = cfg.hostname;

      firewall = mkIf cfg.firewall.enable {
        enable = true;

        allowedTCPPorts = unique (cfg.firewall.openTCPPorts ++ tcpPorts);
        allowedUDPPorts = unique (cfg.firewall.openUDPPorts ++ udpPorts);
      };
    };
  };
}
