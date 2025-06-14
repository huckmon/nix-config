{ lib, pkgs, config, ... }:
let
  cfg = config.customModules.services;
in
{

  options.customModules.services = {
    enable = lib.mkEnableOption "Server settings and services";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      docker-compose
    ];
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = false;
        defaultNetwork.settings = {
          dns_enabled = true;
        };
      };
      docker.enable = true;
      oci-containers.backend = "podman";
    };
    networking.firewall.interfaces.podman0.allowedUDPPorts = [ 53 ]; # podman port
    networking.firewall.trustedInterfaces = [ "docker0" "podman0" ];
  };

  imports = [
    ./arr/prowlarr
    ./arr/sonarr
    ./arr/radarr
    ./arr/readarr
    ./arr/flaresolverr
    ./deluge
    ./jellyfin
    ./nginxproxymanager
    ./vaultwarden
    #./wireguard
  ];
}
