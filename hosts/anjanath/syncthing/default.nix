{ config, ... }:

{

  #networking.firewall = {
    #allowedTCPPorts = [ 8384 22000 ];
    #allowedUDPPorts = [ 22000 21027 ];
  #}; 

  services = {
   syncthing = {
      enable = true;
      guiAddress = "0.0.0.0:8384";
      openDefaultPorts = true;
      user = "share";
      dataDir = "/home/huck/Documents/syncthing";
      configDir = "/home/huck/Documents/.config/syncthing";
      overrideDevices = false;
      overrideFolders = false;
    };
  };

}
