
{ config, pkgs, ... }:

{
  imports =
    [
    ];

  environment.systemPackages = with pkgs; [
    podman
    podman-compose
    docker-compose
  ];


  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    extraPackages = [ pkgs.zfs ];
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };
  virtualisation.oci-containers = {
    backend = "podman";
  };
  virtualisation.docker = {
    enable = true;
  };
  networking.firewall.interfaces.podman0.allowedUDPPorts = [ 53 ]; # podman port
  networking.firewall.trustedInterfaces = [ "docker0" ];

}
