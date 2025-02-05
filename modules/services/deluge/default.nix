{ config, lib, vars, ... }:
#let
#  directories = [
#    "${vars.mainArray}/Media/downloads"
#    "${vars.serviceConfigDir}/deluge"
#  ];
#in
{
#  systemd.tmpfiles.rules = map (x: "d ${x} 0775 share share - -") directories;
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

  options.custModules.services.deluge = {
    enable = lib.mkEnableOption "Enable Deluge client";
    configDir = lib.mkOption {
      default = "/var/lib/deluge";
    };
  };
    
  config = lib.mkIf config.custModules.services.deluge.enable {
    services.deluge = {
      enable = true;
      user = config.custModules.user;
      group = config.custModules.group;
      web = {
        enable = true;
	openFirewall = true;
      };
    };
  };
}
