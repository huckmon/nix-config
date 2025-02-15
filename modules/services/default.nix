{ lib, pkgs, config, ... }:

{

  options.customModules.services = {
    enable = lib.mkEnableOption "Server settings and services";
  };

  config = lib.mkIf config.customModules.services.enable {
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
    networking.firewall.trustedInterfaces = [ "docker0" ];
  };

  imports = [
    ./arr/prowlarr
    ./arr/sonarr
    ./arr/radarr
    #./arr
    ./deluge
    ./jellyfin
    ./nginxproxymanager
    ./vaultwarden
    #./wireguard
  ];
}
