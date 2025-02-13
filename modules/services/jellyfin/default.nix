{ config, vars, lib, ... }:
#let     
#  directories = [     
#    "${vars.serviceConfigDir}/jellyfin"
#  ];
#in
{
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  virtualisation.oci-containers = {
    containers = {
      jellyfin = {
        image = "lscr.io/linuxserver/jellyfin";
        autoStart = true;
        extraOptions = [
          "--device=/dev/dri/renderD128:/dev/dri/renderD128" 
          # Adds HW Acceleration for Intel QuickSync by mounting the video device. renderD128 is specifically capalbe of rendering, but not video output(?)
        ];
        volumes = [
          "/home/jellyfin/config:/config"
          "/mnt/user/Media/anime:/data/media"
          "/mnt/user/Media/movies:/data/movies"
          "/mnt/user/Media/tv:/data/tvshows"
	  "/mnt/user/Media/books:/data/books"
#	  "${vars.serviceConfigDir}/jellyfin:/config"
#	  "${vars.mainArray}/Media/anime:/data/media"
#	  "${vars.mainArray}/Media/movies:/data/movies"
#	  "${vars.mainArray}/Media/tv:/data/tvshows"
#	  "${vars.mainArray}/Media/books:/data/books"
        ];
        ports = [ "8096:8096" ];
        environment = {
          PUID = "994";
          UMASK = "002";
          GUID = "993";
          DOCKER_MODS = "linuxserver/mods:jellyfin-opencl-intel"; #Adds OpenCL-intel to jellyfin
        };
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 8096 ];
  };

  options.custModules.services.jellyfin = {
    enable = lib.mkEnableOption "Enable Jellyfin service";
    configDir = lib.mkOption {
      default = "var/lib/jellyfin"
    };
  };

}
