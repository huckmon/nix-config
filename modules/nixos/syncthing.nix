{ config, pkgs, ... }:

{
  imports =
    [ 
      
    ];

  environment.systemPackages = with pkgs; [
    syncthing
  ];

  services = {
   syncthing = {
      enable = true;
      guiAddress = "0.0.0.0:8384";
      openDefaultPorts = true;
      user = "huck";
      group = "users";
      dataDir = "/home/huck/Documents/syncthing";
      configDir = "/home/huck/Documents/.config/syncthing";
      overrideDevices = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders = true;     # overrides any folders added or deleted through the WebUI

      settings = {

        devices = {
          "rathalos" = { id = "UQX47QB-SXQGNFY-AP22RQR-AMHVYLF-GQRBWT4-OXNH7MO-YC335VN-UKWKXQU"; };
          "greatjaggi" = { id = "DRXDEUS-RI64LJ3-644UBST-HKERGJF-OLDSLKL-T2OXKNV-EA52M45-D72XZQU"; };
          "rathian" = { id = "FLWAH3V-PKBAHLZ-HQQ3D3X-QHSWPC5-XZC2X6J-KDP37LI-R5MUI6Y-N7QK4AF"; };
        };

        folders = {
          "Obsidian-vault" = {                                    # Name of folder in Syncthing, also the folder ID
            path = "/home/huck/Documents/syncthing/Obsidian";     # Which folder to add to Syncthing
            devices = [ "rathalos" "greatjaggi" "rathian" ];                     # Which devices to share the folder with
            versioning = {
              type = "staggered";
              params = {
                cleanInterval = "3600";
                maxAge = "2592000";
              };
            };
          };
        };

      };

    };
  };

  # Syncthing required ports for headless server
  networking.firewall.allowedTCPPorts = [ 8384 ];
  #networking.firewall.allowedUDPPorts = [ 22000 21027 ];


}
