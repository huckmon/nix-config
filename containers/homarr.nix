{ config, vars, ... }:
{
  virtualisation.oci-containers = {
    containers = {
      homarr = {
        image = "ghcr.io/ajnart/homarr:latest";
        autoStart = true;
        volumes = [
          #"/var/run/docker.sock:/var/run/docker.sock" #optional for docker intergration
          "/home/homarr/config:/apps/data/configs"
	  "/home/homarr/icons:/apps/public/icons"
	  "/home/homarr/data:/data"
        ];
        ports = [
          "7575:7575"
        ];
      };
    };
  };
}
