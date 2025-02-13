{ config, lib, vars, ... }:
let
  service = "deluge";
  cfgerv = config.customModules.services.${service};
  cfg = config.customModules;
in
{
#  virtualisation.oci-containers = {
#    containers = {
#      deluge = {
#        image = "lscr.io/linuxserver/deluge:latest";
#        autoStart = true;
#        volumes = [
#          "/mnt/user/Media/downloads:/downloads"
#          "/home/deluge/config:/config"
#        ];
#        environment = {
#          PUID = "994";
#          GUID = "993";
#          TZ = "Etc/UTC";
#        };
#        ports = [
#          "8112:8112"
#          "6881:6881"
#          "6881:6881/udp"
#          "58846:58846"
#        ];
#      };
#    };
#  };

#  networking.firewall = {
#    allowedTCPPorts = [ 8112 6881 58846 ];
#    allowedUDPPorts = [ 6881 ];
#  };

  options.cfgServ = {
    enable = lib.mkEnableOption "Enable Deluge client";
    configDir = lib.mkOption {
      default = "/var/lib/${service}";
    };
  };    
  config = lib.mkIf cfgServ.enable {
    services.${service} = {
      enable = true;
      user = cfg.user;
      group = cfg.group;
      web = {
        enable = true;
      openFirewall = true;
      };
    };
  };
}

