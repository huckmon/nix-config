{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

}
