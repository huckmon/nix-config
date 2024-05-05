{ config, vars, ... }:

{

  virtualisation.oci-containers = {
    containers = {
      paperless = {
	image = "ghcr.io/paperless-ngx/paperless-ngx";
	autoStart = true;
	extraOptions = [
	];
	volumes = [
	  "/mnt/user/Documents/Paperless/Documents:/usr/src/paperless/media"
	  "/mnt/user/Documents/Paperless/Import:/usr/src/paperless/consume"
	  "/mnt/user/Documents/Paperless/Export:/usr/src/paperless/export"
	  "/home/Paperless/data:/usr/src/paperless/data"
	];
	ports = [
	  "8000:8000"
	];
      };
    };
  };
}
