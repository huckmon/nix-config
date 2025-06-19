{ config, pkgs, lib, ... }:
let
    cfg = config.customModules;
in
{
  options.customModules.gameCompat = {
    enable = lib.mkEnableOption "Enables gameCompat module for wine, wintricks, etc";
  };

  config = lib.mkIf cfg.gameCompat.enable {

    environment.systemPackages = with pkgs; [
        winetricks
        protontricks
        wineWowPackages.stable
        lutris
        zenity
        yad
        p7zip
    ];

  };

}
