{ config, pkgs, lib, ... }:
let
  service = "jellyfin";
  cfgServ = config.customModules.services.${service};
  cfg = config.customModules;
in
{

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

#  options.customModules.services.${service} = {
#    enable = lib.mkEnableOption "Enable ${service} service";
#    configDir = lib.mkOption {
#      default = "var/lib/${service}";
#    };
#  };

#  config = lib.mkIf cfg.enable {
#    nixpkgs.config.packageOverrides = pkgs: {
#      vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true; };
#    };
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        vaapiVdpau
	libvdpau-va-gl
        intel-compute-runtime
        intel-media-sdk
      ];
    };
#    services.${service} = {
#      enable = true;
#      user = cfg.user;
#      group = cfg.group;
#      openFirewall = true;
#    };
#    environment.systemPackages = with pkgs; [
#      jellyfin
#      jellyfin-web
#      jellyfin-ffmpeg
#    ];
#  };

}
