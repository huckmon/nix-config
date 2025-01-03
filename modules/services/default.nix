{ lib, pkgs, config, ... }:

{

  options.servicesConfig = {
    enable = lib.mkEnableOption "Server settings and services";
  };

  config = lib.mkIf config.servicesConfig.enable { 
    

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

    networking.firewall.interfaces.podman0.allowedUDPPorts = [ 53 ];
    networking.firewall.trustedInterfaces = [ "docker0" ];

  };


  imports = [
    ./arr
    ./deluge
    ./jellyfin
    ./nginxproxymanager
    ./vaultwarden
    #./wireguard
  ];

}
