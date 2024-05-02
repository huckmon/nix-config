{ config, vars, ... }:
#let
#directories = [
#"/home/deluge"
#"/mnt/user/downloads"
#];
#  in
{
#  systemd.tmpfiles.rules = map (x: "d ${x} 0775 share share - -") directories;
  #systemd.tmpfiles.rules = [
    #"d /mnt/user/Media/deluge 0775 share share - -"
  #];
  virtualisation.oci-containers = {
    containers = {
      deluge = {
        image = "lscr.io/linuxserver/deluge:latest";
        autoStart = true;
        volumes = [
          "/mnt/user/Media/downloads:/downloads"
          "/home/deluge/config:/config"
        ];
        environment = {
          PUID = "994";
          GUID = "993";
          TZ = "Etc/UTC";
        };
        ports = [
          "8112:8112"
          "6881:6881"
          "6881:6881/udp"
          "58846:58846"
        ];
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 
			8112 
			6881 
			58846
		      ];
    allowedUDPPorts = [ 6881 ];
  };


}
