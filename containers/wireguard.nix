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
      wireguard = {
        image = "lscr.io/linuxserver/wireguard:latest";
        autoStart = true;
        volumes = [
          "/home/wireguard/config:/config"
        ];
        environment = {
          PUID = "1000";
          GUID = "1000";
          TZ = "Etc/UTC";
	  SERVERURL = "auto"
	  SERVERPORT = "69691"
	  PEERS = "peer1,peer2"
	  PEERDNS = "1.1.1.2,1.0.0.2"
	  ALLOWEDIPS = "0.0.0.0/0"
        };
        ports = [
          "69691:51820/udp"
        ];
      };
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ 69691 ];
  };


}
