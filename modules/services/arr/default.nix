{ config, vars, ... }:

{
  #systemd.tmpfiles.rules = map (x: "d ${x} 0775 share share - -") directories;
  virtualisation.oci-containers = {
    containers = {
      prowlarr = {
        image = "lscr.io/linuxserver/prowlarr:latest";
        autoStart = true;
	ports = [
	  "9696:9696"
	];
        volumes = [
          "/home/arr/prowlarr:/config"
        ];
        environment = {
          TZ = "Australia/Adelaide";
          PUID = "994";
          GUID = "993";
          UMASK = "002";
        };
      };
      flaresolverr = {
	image = "ghcr.io/flaresolverr/flaresolverr:latest";
	autoStart = true;
	environment = {
	  TZ = "Australia/Adelaide";
	};
	ports = [
	  "8191:8191"
	];
      };
      sonarr = {
        image = "lscr.io/linuxserver/sonarr:latest";
        autoStart = true;
	ports = [
	  "8989:8989"
	];
        volumes = [
          "/mnt/user/Media/downloads:/mnt/user/Media/downloads"
          "/mnt/user/Media/tv:/tv"
          "/mnt/user/Media/anime:/anime"
          "/home/arr/sonarr:/config"
        ];
        environment = {
          TZ = "Australia/Adelaide";
          PUID = "994";
          GUID = "993";
          UMASK = "002";
        };
      };
      radarr = {
        image = "lscr.io/linuxserver/radarr:latest";
        autoStart = true;
	ports = [
	  "7878:7878"
	];
        volumes = [
          "/mnt/user/Media/downloads:/mnt/user/Media/downloads"
          "/mnt/user/Media/movies:/movies"
          "/mnt/user/Media/anime:/anime"
          "/home/arr/radarr:/config"
        ];
        environment = {
          TZ = "Australia/Adelaide";
          PUID = "994";
          GUID = "993";
          UMASK = "002";
        };
      };
#      readarr = {
#        image = "lscr.io/linuxserver/readarr:develop";
#        autoStart = true;
#        ports = [
#          "8787:8787"
#        ];
#        volumes = [
#            "/mnt/user/Media/downloads:/develop"
#            "/mnt/user/Media/books:/books"
#            "/home/arr/readarr:/config"
#        ];
#        environment = {
#          TZ = "Australia/Adelaide";
#          PUID = "994";
#          GUID = "993";
#          UMASK = "002";
#        };
#      };

    };
  };
}
