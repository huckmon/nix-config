
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
      openDefaultPorts = true;
      user = "huck";
      group = "users";
      dataDir = "/home/huck/Documents/syncthing";
      configDir = "/home/huck/Documents/.config/syncthing";
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        devices = {
          "desktop" = { id = "UQX47QB-SXQGNFY-AP22RQR-AMHVYLF-GQRBWT4-OXNH7MO-YC335VN-UKWKXQU"; };
          "laptop" = { id = "DRXDEUS-RI64LJ3-644UBST-HKERGJF-OLDSLKL-T2OXKNV-EA52M45-D72XZQU"; };
        };
        folders = {
          "Obsidian-vault" = {                                    # Name of folder in Syncthing, also the folder ID
            path = "/home/huck/Documents/syncthing/Obsidian";     # Which folder to add to Syncthing
            devices = [ "desktop" "laptop" ];                     # Which devices to share the folder with
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

}
