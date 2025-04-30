# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./shares/samba.nix
      inputs.home-manager.nixosModules.default
      inputs.sops-nix.nixosModules.sops
      #../../modules/nixos/hyprland.nix
      ../../modules/nixos/syncthing.nix
      ../../modules/nixos/plasma.nix
      ../../modules/nixos/libreoffice.nix
      ../../modules/nixos/virt-manager.nix
      ../../modules/nixos/steam.nix
      ../../modules/nixos/networkfs.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  home-manager = {
    # also pass inputs to homemanager modules
    extraSpecialArgs = { inherit inputs; };
    users = {
      "huck" = import ./home.nix;
    };
  };

  # sops-nix configuration - move to it's own file
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/huck/.config/sops/age/keys.txt";

#  sops.secrets.example-key = { };
#  sops.secrets."myservice/my_subdir/my_secret"= {
#    owner = config.users.users.huck.name;
#  };

#  sops.secrets.samba = { };
  sops.secrets."samba/user"= {
#  owner = config.users.users.huck.name;
  };
  sops.secrets."samba/password"= { 
#    owner = config.users.users.huck.name;
  };


  # smb mount
  fileSystems."/mnt/share" = {
    device = "//192.168.60.219/Media";
    fsType = "cifs";
#    options = [ 
#        "username=share" 
#        "password=" 
#	 "credentials=/etc/nixos/smb-secrets,uid=994,gid=993"
#        "x-system.automount" 
#        "noauto" 
#      ];
    options = let 
      
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";

    in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1001,gid=100"];
  };


  # part of enabling smb mount as user
#  security.wrapper."mount.cifs" = {
#    program = "mount.cifs";
#    source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
#    owner = "root";
#    group = "root";


  #hardware = {
    #bluetooth.enable = true;
  services.pulseaudio = {
    support32Bit = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

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

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # User. Don't forget to set a password with ‘passwd’.
  users = {
    motdFile = "/etc/motd";
    users.huck = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
        firefox
        tree
        discord
        signal-desktop
        obsidian
        prismlauncher
	ascii-image-converter
      ];
    };
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
    powertop
    pciutils
    dolphin-emu
    melonDS
    lutris
    dolphin
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
    power-profiles-daemon # power profiles for kde
    python3
    jellyfin-media-player
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Powertop settings
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # fixes audio popping caused by powertop audio tuning
  systemd.services.audio-fix = {
    script = ''
      echo 0 | tee /sys/module/snd_hda_intel/parameters/power_save
    '';
    wantedBy = [ "multi-user.target" ];
  };

  # prevents pipewire from nuking battery by making it ignore cameras
  services.pipewire.wireplumber.extraConfig = {
    "10-disable-camera" = {
      "wireplumber.profiles" = {
        main = {
	  "monitor.libcamera" = "disabled";
	};
      };
    };
  };

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
