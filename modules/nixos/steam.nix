{ config, pkgs, inputs, ... }:

{
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true; # wrapper command for running in optimised micro compositor
  programs.gamemode.enable = true; # temporarily requests of optimisations to OS and game process

  # NOTE to take effect of any of these, they need to be added as steam launch options
  # gamemoderun %command% gamescope %command%

  environment.systemPackages = with pkgs; [
    steam
    mangohud
  ];

}
