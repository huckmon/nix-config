{ config, pkgs, inputs, ... }:

{

  environment.systemPackages = with pkgs; [
      cifs-utils
      samba
    ];

  services.samba.enable = true;
  services.samba.openFirewall = true;
  services.samba.smbd.enable = true;

  # smb mount
#  fileSystems."/mnt/share" = {
#    device = "//192.168.60.219/";
#    fsType = "cifs";
#    options = [ 
#        "username=${config.sops.secrets."samba/user".path}" 
#        "password=${config.sops.secrets."samba/password".path}" 
#        "x-system.automount" 
#        "noauto" 
#      ];
#  };

}
