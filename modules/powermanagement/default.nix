{ config, pkgs, lib, ... }:
let
  service = "powerManagement";
  cfgServ = config.customModules.${service};
  cfg = config.customModules;
in
{

  options.customModules.${service} = {
    enable = lib.mkEnableOption "Enable power management module";
    hd-idle = lib.mkEnableOption "Enable hd-idle service";
    powertopAudioFix = lib.mkEnableOption "Fix audio popping caused by powertop";
    pipewireCameraFix = lib.mkEnableOption "Fix pipewire power drain by ignoring camera";
  };



  #boot.kernalParams = [ "pcie_aspm=force" ] # CANT USE not all components have ASPM functionality
  config = lib.mkIf cfgServ.enable {
    powerManagement.powertop.enable = true;

    environment.systemPackages = with pkgs; [
      powertop
      hd-idle
      hdparm
      pciutils
    ];
  };

  # Service to spin down drives after 5 minutes of idle
  hd-idle-config = lib.mkIf cfgServ.hd-idle {
    systemd.services.hd-idle = {
      description = "HD spin down daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.hd-idle}/bin/hd-idle -i 900";
      };
    };
  };



  # add service to run autoaspm.py after poweron

  #system.activationScripts = { "/};

  # fixes audio popping caused by powertop audio tuning
  powertopAudioFix = lib.mkIf cfgServ.powertopAudioFix {
    systemd.services.audio-fix = {
      script = ''
        echo 0 | tee /sys/module/snd_hda_intel/parameters/power_save
      '';
      wantedBy = [ "multi-user.target" ];
    };
  };

  # prevents pipewire from nuking battery by making it ignore cameras
  pipewireCameraFix = lib.mkIf cfgServ.pipewireCameraFix {
    services.pipewire.wireplumber.extraConfig = {
      "10-disable-camera" = {
        "wireplumber.profiles" = {
          main = {
        "monitor.libcamera" = "disabled";
      };
        };
      };
    };
  };


}
