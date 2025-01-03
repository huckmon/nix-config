{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
     
    ];

  environment.systemPackages = with pkgs; [
    powertop
    hd-idle
    hdparm
    tlp
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

  powerManagement.powertop.enable = true;

}
