{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.networks;

  serviceAttributes = {
    localsend = {
      tcp = [ 53317 ];
      udp = [ 53317 ];
      packages = with pkgs; [
        localsend_app
      ];
    };

    uxplay = {
      tcp = [
        7000
        7001
        7011
      ];
      udp = [
        5353
        6000
        6001
        6011
      ];
      packages = with pkgs; [
        uxplay
        avahi-compat
        gst_all_1.gstreamer
        gnomeExtensions.uxplay-control
      ];
    };
  };

  tcpPorts = concatLists (map
    (s: serviceAttributes.${s}.tcp)
    cfg.firewall.activeServices
  );
  udpPorts = concatLists (map
    (s: serviceAttributes.${s}.udp)
    cfg.firewall.activeServices
  );
  addlPackages = concatLists (map
    (s: serviceAttributes.${s}.packages)
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
          (attrNames serviceAttributes)
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

    services = {
      avahi = {
        enable = builtins.elem "uxplay" cfg.firewall.activeServices;
        nssmdns4 = true;

        publish = {
          enable = true;
          userServices = true;
          addresses = true;
        };

        openFirewall = true; 
      };
    };

    environment.systemPackages = addlPackages;
  };
}
