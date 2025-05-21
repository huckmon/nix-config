# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      inputs.sops-nix.nixosModules.sops
      ./syncthing
      ../../modules
      ../../dots/kate
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  home-manager = {
    # also pass inputs to homemanager modules
    extraSpecialArgs = { inherit inputs; };
    users = {
      "huck" = import ./home.nix;
    };
  };

  customModules = {
    powerManagement = {
      enable = true;
      powertopAudioFix = true;
      pipewireCameraFix = true;
    };
  };

  # sops-nix configuration - move to it's own file
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/huck/.config/sops/age/keys.txt";
    secrets = {
      "samba/user"= {};
      "samba/password"= {};
    };
  };

  # smb mount
  fileSystems."/mnt/share" = {
    device = "//192.168.60.219/Media";
    fsType = "cifs";
    options = let

      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";

    in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1001,gid=100"];
  };

  hardware = {
    pulseaudio.support32Bit = true;
    graphics = {
    enable = true;
    enable32Bit = true;
    };
  };

  services.flatpak.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.hostName = "greatjaggi"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.firewall.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Adelaide";

  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neofetch
    htop
    python312Packages.ds4drv
    podman
    powertop              # redundant due to powermanagement module
    pciutils
    dolphin-emu           # game related
    melonDS               # game related
    lutris
    libsForQt5.dolphin
    pulseaudio
    appimage-run
    sops
    vlc
    keepassxc
    (lutris.override {
           extraPkgs = pkgs: [
             wineWowPackages.stable
             winetricks
           ];
    })
    gnupg
    gnupg1
    git
    gimp
    power-profiles-daemon   # power profiles for kde
    python3
    jellyfin-media-player
    mission-center
    librewolf
    obs-studio
    libqalculate
    qalculate-qt
    floorp
    firefox
    tree
    discord
    signal-desktop
    obsidian
	ascii-image-converter
	wine
    brightnessctl		     # screen brightness tool
    pamixer
    playerctl
    xdg-user-dirs            # tool to help well known user dirs
    libreoffice
    hunspell
    hunspellDicts.en_AU
    steam
    mangohud                # steam, to breakout
    samba
    cifs-utils
    github-desktop
    godot
    tmux
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # Powertop settings
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # services are used to connect to share
  services.samba.enable = true;
  services.samba.openFirewall = true;
  services.samba.smbd.enable = true;
  services.gvfs.enable = true;

  # steam config
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true; # wrapper command for running in optimised micro compositor
  programs.gamemode.enable = true; # temporarily requests of optimisations to OS and game process
  # NOTE to take effect of any of these, they need to be added as steam launch options
  # gamemoderun %command% gamescope %command%


  # Enable the X11 windowing system.
  services.xserver.enable = true; # enable X11 for xwayand
  services.displayManager.sddm.enable = true; # enable simple desktop display manager
  services.desktopManager.plasma6.enable = true; # enable plasma6, move to kde module

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
