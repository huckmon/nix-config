{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  # smb mount
  fileSystems."/mnt/media" = {
    device = "//192.168.60.219/Media";
    fstype = "cifs";
    options = [
      "username=share";
      "password=password";
      "x-system.automount";
      "noauto";
    ];
  };

}
