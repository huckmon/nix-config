{ config, pkgs, ... }: 

{
  virtualisation.oci-containers = {
    containers = {
      nginxproxymanager = {
        image = "jc21/nginx-proxy-manager:latest";
	autoStart = true;
	volumes = [
	  "/srv/nginx/data:/data"
	  "/srv/nginx/letsencrypt:/etc/letsencrypt"
	];
	ports = [
	  "80:80"
	  "81:81"
	  "443:443"
	];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    81
    443
  ];

}
