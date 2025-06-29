{ config, pkgs, inputs, vars, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./filesystems
      ./shares
      ./syncthing
      ../../modules
      ../../modules/services
    ]; 

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # custom option for services configs
  customModules = {
    enable = true;
    powerManagement = {
      enable = true;
      hd-idle = true;
    };
    services = {
      enable = true;
      deluge.enable = true;
      sonarr.enable = true;
      radarr.enable = true;
      readarr.enable = true;
      prowlarr.enable = true;
      flaresolverr.enable = true;
      jellyfin.enable = true;
      vaultwarden.enable = true;
      nginxproxymanager.enable = true;
    };
    samba = {
      enable = true;
    };
  };

  powerManagement.powertop.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "goremagala";
  networking.firewall.enable = true;

  # time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    vim
    wget
    docker-compose
    neofetch
    parted
    git
    htop
    iotop
    tree
    appimage-run
    ascii-image-converter
    unzip
    libnotify
    file
    python312
    intel-gpu-tools
    rsync
    tmux
    pciutils
    powertop
    smartmontools
    e2fsprogs
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh = { 
    enable = true;
    #ports = [ ];
    settings = {
      PrintMotd = true;
      #Password
    };
  };

  system.stateVersion = "23.05"; # Did you read the comment?
}
