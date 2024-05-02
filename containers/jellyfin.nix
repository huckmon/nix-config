  { config, lib, pkgs, ... }:

  {

  environment.systemPackages = with pkgs; [
    podman
    podman-compose
  ];

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
          "--device=/dev/dri/renderD128:/dev/dri/renderD128" #Adds HW Acceleration for Intel QuickSync by mounting the video device. renderD128 is specifically capalbe of rendering, but not video output(?)
        ];
        volumes = [
          "/home/jellyfin/config:/config"
          "/mnt/user/Media/anime:/data/media"
          "/mnt/user/Media/movies:/data/movies"
          "/mnt/user/Media/tv:/data/tvshows"
	  "/mnt/user/Media/books:/data/books"
        ];
        ports = [ "8096:8096" ];
        environment = {
          PUID = "994";
          UMASK = "002";
          GUID = "993";
          DOCKER_MODS = "linuxserver/mods:jellyfin-opencl-intel"; #Adds OpenCL-intel to jellyfin
	  #ROC_ENABLE_PRE_VEGA = "1"; #Installs ROCm OpenCL runtime
        };
      };
    };
  };
  networking.firewall = {
    allowedTCPPorts = [ 8096 ];
    #allowedUDPPorts = [ ];
  };


  }
