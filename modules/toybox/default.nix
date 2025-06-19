{ config, pkgs, lib, ... }:
let
    cfg = config.customModules;
in
{
  options.customModules.toybox = {
    enable = lib.mkEnableOption "Enables toybox module for file, which, etc";
  };

  config = lib.mkIf cfg.toybox.enable {

    environment.systemPackages = with pkgs; [
        file
        which
        dd
        find
        sort
        wget
        sed
        seq
        dos2unix
        unix2dos
    ];

  };

}
