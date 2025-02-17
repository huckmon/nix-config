{ config, pkgs, ... }:
let
  service = "jellyfin";
  cfgServ = config.customModules.services.${service};
  cfg = config.customModules;
in
{
  environment.systemPackages = with pkgs; [
    powertop
    hd-idle
    hdparm
    pciutils
  ];

  #boot.kernalParams = [ "pcie_aspm=force" ] # CANT USE not all components have ASPM functionality

  systemd.services.hd-idle = {
    description = "HD spin down daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hd-idle}/bin/hd-idle -i 900";
    };
  };

  # add service to run autoaspm.py after poweron

  powerManagement.powertop.enable = true;

  #system.activationScripts = { "/};

}
