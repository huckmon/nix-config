{ config, lib, vars, ... }:
let
  service = "deluge";
  cfg = config.customModules.services.${service};
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

  options.customModules.services.${service} = {
    enable = lib.mkEnableOption "Enable Deluge client";
    configDir = lib.mkOption {
      default = "/var/lib/deluge";
    };
  };    
  config = lib.mkIf cfg.enable {
    services.deluge = {
      enable = true;
      user = config.customModules.user;
      group = config.customModules.group;
      web = {
        enable = true;
      openFirewall = true;
      };
    };
  };
}

