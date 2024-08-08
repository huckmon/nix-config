{ config, pkgs, ... }:

let
  #hyprland startup script
  startScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww init &

    ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &

    sleep 1

    ${pkgs.swww}/bin/swww img ~/wallpaper/foggyForest.png &
    ${pkgs.dunst}/bin/dunst &
    ${pkgs.keepassxc}/bin/keepassxc
  '';
  #swayidle script to lock screen after set time
  swayidleSleepScript = pkgs.pkgs.writeShellScriptBin "start" ''
    swayidle -w \
    timeout 300 'swaylock -f -c 000000 -e' \
    timeout 420 'systemctl suspend' \
    resume 'swaylock -f -c 000000 -e'& 
  '';
  #lockScript = pkgs.pkgs.writeShellScriptBin "start" ''
  #  swayidle -w \
  #  timeout 1 'swaylock -f -c 000000 -e' \
  #  timeout 120 'systemctl suspend' \
  #  resume 'swaylock -f -c 000000 -e'& 
  #'';

  #start of a sleep script for closing the laptop lid
   # if grep open /proc/acpi/button/lid/LID0/state; then
   #     hyprctl keyword monitor ",2556x1504,auto,1.5"
   # else
   #     if [[ `hyprctl monitors | grep Monitor" | wc -1` != 1 ]]; then
   #         hyprctl keyword monitor "eDP-1, disable"
   #     fi
   # fi
in
{
  wayland.windowManager.hyprland = {
    # allow home-manager to configure hyprland
    enable = true;
    settings = {

      monitor=",2256x1504,auto,1";

      general = {
        gaps_in = 5;
	gaps_out = 20;
	border_size = 2;
	"col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
	"col.inactive_border" = "rgba(595959aa)";

	layout = "dwindle";

	allow_tearing = false;
      };

      decoration = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more

    	rounding = 10;

    	blur = {
          enabled = true;
          size = 6; #3
          passes = 2; #1
          new_optimizations = true; #on
          ignore_opacity = true;
          xray = true;
    	};

    	active_opacity = "1.0";
    	inactive_opacity = "0.8";
    	fullscreen_opacity = "1.0";

    	drop_shadow = true; #yes
    	shadow_range = 30; #4
    	shadow_render_power = 3;
    	"col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
    	enabled = true;
    	# Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    	bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

    	animation = [
	  "windows, 1, 7, myBezier"
    	  "windowsOut, 1, 7, default, popin 80%"
    	  "border, 1, 10, default"
    	  "borderangle, 1, 8, default"
    	  "fade, 1, 7, default"
    	  "workspaces, 1, 6, default"
	];
      };

      dwindle = {
    	# See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    	pseudotile = true; #yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    	preserve_split = true; #yes # you probably want this
      };

      master = {
    	# See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    	new_is_master = true;
      };

      gestures = {
    	# See https://wiki.hyprland.org/Configuring/Variables/ for more
    	workspace_swipe = false; #off
      };

      misc = {
    	# See https://wiki.hyprland.org/Configuring/Variables/ for more
    	force_default_wallpaper = "-1"; # Set to 0 to disable the anime mascot wallpapers
      };

      # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
      device = {
	name = "epic-mouse-v1";
    	sensitivity = "-0.5";
      };

      #windowrulev2 = "nomaximizerequest, class:.*"; # You'll probably like this.

      exec-once = [
        ''${pkgs.bash}/bin/bash ${startScript}/bin/start'' #hyprland startup script
        ''${swayidleSleepScript}/bin/start'' #idle suspend script
	#''${pkgs.bash}/bin/bash sway-audio-idle-inhibit''
      ];
      #exec = [ ''${pkgs.bash}/bin/bash sway-audio-idle-inhibit'' ]

      "$mod" = "$SUPER";

      #"$terminal" = "${pkgs.kitty}/bin/kitty";
      #"$fileManager" = "${pkgs.dolphin}dolphin";
      #"$menu" = "${pkgs.wofi}/bin/wofi --show-drun";

      bind = [
	"$mod, Q, exec, kitty"
	"$mod, C, killactive"
	"$mod, M, exit"
	"$mod, E, exec, thunar #$fileManager"
	"$mod, V, togglefloating"
	"$mod, R, exec, wofi --show-drun"
	"$mod, P, pseudo" # dwindle(?)
	"$mod, J, togglesplit" # dwindle(?)
	"$mod, T, togglefloating"
	"$mod, F, fullscreen"
	"$mod, A, exec, rofi -show drun -show-icons"

	# Move focus with mainMod + arrow keys
	"$mod, left, movefocus, l"
	"$mod, right, movefocus, r"
	"$mod, up, movefocus, u"
	"$mod, down, movefocus, d"

	# Switch workspaces with mainMod + [0-9]
	"$mod, 1, workspace, 1"
	"$mod, 2, workspace, 2"
	"$mod, 3, workspace, 3"
	"$mod, 4, workspace, 4"
	"$mod, 5, workspace, 5"
	"$mod, 6, workspace, 6"
	"$mod, 7, workspace, 7"
	"$mod, 8, workspace, 8"
	"$mod, 9, workspace, 9"
	"$mod, 0, workspace, 10"

	# Move active window to a workspace with mainMod + SHIFT + [0-9]
	"$mod SHIFT, 1, movetoworkspace, 1"
	"$mod SHIFT, 2, movetoworkspace, 2"
	"$mod SHIFT, 3, movetoworkspace, 3"
	"$mod SHIFT, 4, movetoworkspace, 4"
	"$mod SHIFT, 5, movetoworkspace, 5"
	"$mod SHIFT, 6, movetoworkspace, 6"
	"$mod SHIFT, 7, movetoworkspace, 7"
	"$mod SHIFT, 8, movetoworkspace, 8"
	"$mod SHIFT, 9, movetoworkspace, 9"
	"$mod SHIFT, 0, movetoworkspace, 10"

	# Example special workspace (scratchpad)
	"$mod, S, togglespecialworkspace, magic"
	"$mod SHIFT, S, movetoworkspace, special:magic"

	# Scroll through existing workspaces with mainMod + scroll
	"$mod, mouse_down, workspace, e+1"
	"$mod, mouse_up, workspace, e-1"

	#Brightness binds (not registering keypresses?)
	",XF86MonBrightnessUp, exec, brightnessctl s +5%"
	",XF86MonBrightnessDown, exec, brightnessctl s 5%-"
	

	#Audio binds
	",XF86AudioRaiseVolume, exec, pamixer -i 5" 
	",XF86AudioLowerVolume, exec, pamixer -d 5"
	",XF86AudioMute, exec, pamixer -t"
	",XF86AudioPlay, exec, playerctl play-pause"
	",XF86AudioPause, exec, playerctl play-pause"
	",XF86AudioNext, exec, playerctl next"
	",XF86AudioPrev, exec, playerctl previous"
	"$mod, P, exec, pamixer --default-source -t" #mute microphone

	#screenshot binds
	#",print, exec, grim $(xdg-user-dir PICTURES)/Screenshots/$(date +'%s_grim.png')"
	#",CTRL, print, exec, grim -g slurp -o $(xdg-user-dir PICTURES)/Screenshots/$(date +'%s_grim.png')"
	#",CTRL SHIFT, print, exec, grim -g slurp $(xdg-user-dir PICTURES)/Screenshots/$(date +'%s_grim.png')"
	", print, exec, grimblast copy area" # user drags box and copies to clipboard

	#screen lock bind
	#"$mod, L, ''${pkgs.bash}/bin/bash ${lockScript}/bin/start''"

	#old screenshot binds
	#bind = , print, exec, grim $(xdg-user-dir PICTURES)/Screenshots/$(date +'%s_grim.png')
	#bind = CTRL, print, exec, grim -g "$(slurp -o)" $(xdg-user-dir PICTURES)/Screenshots/$(date +'%s_grim.png')
	#bind = CTRL SHIFT, print, exec, grim -g "$(slurp)" $(xdg-user-dir PICTURES)/Screenshots/$(date +'%s_grim.png')
      ];
      bindm = [
	# Move/resize windows with mainMod + LMB/RMB and dragging
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };

    #home.packages = with pkgs; [
    #  swayidle                    #system idle util
    #  swaylock                    #screen lock util
    #  brightnessctl
    #  grim                        #screenshot util
    #  slurp                       #for use with grim
    #  wl-clipboard                #cli copy paste utils for wayland
    #  feh                         #image viewer
    #  xdg-user-dirs               #tool to help well known user dirs
    #  waybar                      #status bar for hyprland, works ootb
    #  dunst                       #notification daemon for hyprland
    #  libnotify                   #required for dunst
    #  swww                        #wallpaper daemon for hyprland
    #  kitty                       #default hyprland terminal emulator
    #  rofi-wayland                #uplauncher for hyprland
    #  qpwgraph                    #qt based gui app for pipewire audio
    #  networkmanagerapplet        #network manager
    #  (pkgs.waybar.overrideAttrs (oldAttrs: {
    #    mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    #  }))
    #];

  };
}
