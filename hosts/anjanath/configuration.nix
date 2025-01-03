
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ../../containers/jellyfin.nix
      ../../containers/deluge.nix
      ../../containers/nginxproxymanager.nix
      ../../containers/vaultwarden.nix
      ../../containers/arr.nix
      ./shares/samba.nix
      ./filesystems/mergerfs-snapraid.nix
      ../../modules/nixos/powermanagement.nix
      ../../modules/nixos/syncthing.nix
      ../../modules/nixos/virtualisation.nix
    ]; 

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "huck" = import ./home.nix;
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "anjanath";
  networking.firewall.enable = true;

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  users = {
    users.huck = { # move to user file
      isNormalUser = true;
      home = "/home/huck";
      extraGroups = [ "wheel" "share" ];
      packages = with pkgs; [
      ];
    };
  };

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    docker-compose	#Virtualisation
    neofetch
    parted
    git
    htop
    iotop		#debug
    tree
    appimage-run
    ascii-image-converter
    unzip
    libnotify
    file
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
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
    #  ForceCommand = ''
    #    bash /usr/amotd.sh
    #  '';
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
  system.stateVersion = "23.05"; # Did you read the comment?
}
