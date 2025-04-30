{ inputs, config, pkgs, lib, ... }:

{

  environment.systemPackages = with pkgs; [
    parted
    gptfdisk
  ];
  
  # Disk mounts

  fileSystems."/mnt/crucialssd" = 
    { device = "/dev/disk/by-uuid/da085350-7459-485a-b19d-9ff26d14be28";
      fsType = "ext4";
      options = [ "defaults" ];
    };
}
