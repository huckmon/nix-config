# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, inputs, ... }:

{
  #may change to a docker container or something similar so it can be shutdown sometimes instead of always on
  #also just move this to a module
  services = {
     syncthing = {
        enable = true;
        user = "huck";
        dataDir = "/home/huck/Documents/syncthing";
        configDir = "/home/huck/Documents/.config/syncthing";
        overrideDevices = true;     # overrides any devices added or deleted through the WebUI
        overrideFolders = true;     # overrides any folders added or deleted through the WebUI
        devices = {
          "desktop" = { id = "UQX47QB-SXQGNFY-AP22RQR-AMHVYLF-GQRBWT4-OXNH7MO-YC335VN-UKWKXQU"; };
          "serveridiot" = { id = "HQ5EGJP-HA55ZMH-EISD7UA-WUYJJPQ-FVVYIGN-OXQ5K2K-RTIGB6U-YQUQKQE"; };
        };
        folders = {
          "Obsidian-vault" = {                               	# Name of folder in Syncthing, also the folder ID
            path = "/home/huck/Documents/syncthing/Obsidian";	# Which folder to add to Syncthing
            devices = [ "desktop" "serveridiot" ];                 	# Which devices to share the folder with
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

  environment.systemPackages = with pkgs; [
    syncthing
  ];
}

