{ inputs, config, pkgs, lib, ... }:

{

  imports = [
    ./snapraid.nix
  ];

  environment.systemPackages = with pkgs; [
    mergerfs
    mergerfs-tools
    exfatprogs
    fuse
    parted
    snapraid
    gptfdisk
  ];

  # Mergerfs section
  programs.fuse.userAllowOther = true;

  # This fixes the weird mergerfs permissions issue
  boot.initrd.systemd.enable = true;
  
  # Disk mounts

  fileSystems."/mnt/data1" =
    { device = "/dev/disk/by-uuid/cfa67f8d-a663-425b-be1e-028c5a5f9c1b";
      fsType = "ext4";
      #options = [ "defaults" ];
    };
  fileSystems."/mnt/data2" =
    { device = "/dev/disk/by-uuid/3d133b0f-a465-4851-a97b-cbfffb1f899b";
      fsType = "ext4";
      #options = [ "defaults" ];
    };
  fileSystems."/mnt/data3" =
    { device = "/dev/disk/by-uuid/caf32c78-82df-40d3-8334-0ece5957a268";
      fsType = "ext4";
      #options = [ "defaults" ];
    };
  fileSystems."/mnt/parity1" =
    { device = "/dev/disk/by-uuid/9c049b92-8f4f-44ba-87cf-99b89cb57dce";
      fsType = "ext4";
      #options = [ "defaults" ];
    };

  fileSystems."/mnt/crucialssd" = 
    { device = "/dev/disk/by-uuid/da085350-7459-485a-b19d-9ff26d14be28";
      fsType = "ext4";
      options = [ "defaults" ];
    };

  # Mergerfs section that makes the combined drive
  fileSystems."/mnt/user" =
    { device = "/mnt/data*";
      options = [ 
        "category.create=ff"
        "defaults"
        "allow_other" 
        "fsname=user"
        "moveonenospc=1"
        "minfreespace=160G"
        "func.getattr=newest"
	"fsname=user"
        "gid=993"
        "uid=994"
        "umask=002"
        "x-mount.mkdir"
      ];
     fsType = "fuse.mergerfs";
    };
}
