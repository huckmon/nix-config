
{ config, pkgs, inputs, ... }:

{
  # hyprland related
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  environment.sessionVariables = {
    # for invisible cursors
    WLR_NO_HARDWARE_CURSORS = "1";
    # electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  # xdg portals, desktop portals, handles interactions between them
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  hardware = {
      # most wayland compositors need this
      nvidia.modesetting.enable = true;
  };

  # Enable policykit to grant reboot and poweroff perms
  security.polkit.enable = true;
  # To get swaylock working
  security.pam.services.swaylock = { };

  fonts.packages = with pkgs; [
    font-awesome
    meslo-lgs-nf
  ];

  environment.systemPackages = with pkgs; [
    swayidle			#system idle util
    swaylock			#screen lock util
    brightnessctl
    pamixer
    playerctl
    grim                	#screenshot util
    slurp			#for use with grim
    grimblast
    wl-clipboard		#cli copy paste utils for wayland
    feh				#image viewer
    xdg-user-dirs       	#tool to help well known user dirs
    waybar              	#status bar for hyprland, works ootb
    dunst               	#notification daemon for hyprland
    libnotify           	#required for dunst
    swww                	#wallpaper daemon for hyprland
    kitty               	#default hyprland terminal emulator
    rofi-wayland        	#uplauncher for hyprland
    qpwgraph            	#qt based gui app for pipewire audio
    networkmanagerapplet	#network manager
    sway-audio-idle-inhibit	#stop swayidle from sleeping while audio source is playing
    xfce.thunar			#xfce file manager
    (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    )
  ];

}
