{ config, vars, ... }:
let
  directories = [
    "/home/syncthing"
    "${vars.serviceConfigDir}/syncthing"
  ];
in
{  
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 share share - -") directories;

  networking.firewall = {
    allowedTCPPorts = [ 8384 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
  }; 

  services = {
    syncthing = {
      enable = true;
      guiAddress = "0.0.0.0:8384";
      openDefaultPorts = false;
      user = "share";
      dataDir = "/home/syncthing";
      configDir = "${vars.serviceConfigDir}/syncthing";
      overrideDevices = false;
      overrideFolders = false;
    };
  };

}
