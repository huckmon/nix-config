{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    power-profiles-daemon
  ];

  services.xserver.enable = true; # enable X11 for xwayand
  services.displayManager.sddm.enable = true; # enable simple desktop display manager
  services.desktopManager.plasma6.enable = true; # enable plasma6, move to kde module

}
