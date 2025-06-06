{ config, vars, inputs, pkgs, ... }:
let
  directories = [
    "/home/syncthing"
    "${vars.serviceConfigDir}/syncthing"
  ];
in
{

  networking.firewall = {
    allowedTCPPorts = [ 8384 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
  };

  services = {
    syncthing = {
      enable = true;
      user = "huck";
      guiAddress = "0.0.0.0:8384";
      openDefaultPorts = false;
      dataDir = "/home/syncthing";
      configDir = "${vars.serviceConfigDir}/syncthing";
      overrideDevices = false;
      overrideFolders = false;
    };
  };

  environment.systemPackages = with pkgs; [
    syncthing
  ];
 
}
