{ config, pkgs, ... }: 

{
  virtualisation.oci-containers = {
    containers = {
      duckdns = {
        image = "lscr.io/linuxserver/duckdns:latest";
	autoStart = true;
	volumes = [
	  "/srv/duckdns/config:/config"
	];
	network_mode
      };
    };
  };

}
