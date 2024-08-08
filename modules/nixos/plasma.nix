{ config, pkgs, inputs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Plasma 5 Desktop Environment.
  # services.xserver.displayManager.setupCommands
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable touchpad support (enabled default in most desktopManager).
  #services.xserver.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
    pamixer
    playerctl
    xdg-user-dirs               #tool to help well known user dirs
  ];

}
