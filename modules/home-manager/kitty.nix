{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    thunar
    gvfs
    sshfs
  ];

}
