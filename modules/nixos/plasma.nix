{ config, pkgs, inputs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true; # enable X11 for xwayand
  services.displayManager.sddm.enable = true; # enable simple desktop display manager 
  services.desktopManager.plasma6.enable = true; # 3nable plasma6

  # Enable touchpad support (enabled default in most desktopManager).
  #services.xserver.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl		# screen brightness tool
    pamixer			
    playerctl			
    xdg-user-dirs               # tool to help well known user dirs
  ];

}
