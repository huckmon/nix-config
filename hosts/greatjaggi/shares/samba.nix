{ config, pkgs, inputs, ... }:

{

  environment.systemPackages = with pkgs; [
      cifs-utils
      samba
    ];

  services.samba.enable = true;
  services.samba.openFirewall = true;
  services.samba.smbd.enable = true;
  #services.gvfs.enable = true;

  # smb mount
  fileSystems."/mnt/share" = {
    device = "//192.168.60.219/Media";
    fsType = "cifs";
    options = let 

      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.de>

    in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=994,gid=993"];
  };


}
