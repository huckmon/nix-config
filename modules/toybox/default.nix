{ config, pkgs, lib, ... }:
let
    cfg = config.customModules;
in
{
  options.customModules.toybox = {
    enable = lib.mkEnableOption "Enables toybox module for utilities";
  };

  config = lib.mkIf cfg.toybox.enable {

    environment.systemPackages = with pkgs; [
        file
        wget
    ];

  };

}
