{ config, lib, pkgs, ... }:

{
  imports = [
    #./duckdns
    ./powermanagement
  ];
}
