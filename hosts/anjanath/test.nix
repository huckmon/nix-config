
{ config, pkgs, ... }:

{
  imports =
    [
    ];

  environment.systemPackages = with pkgs; [
    vim
  ];

}
