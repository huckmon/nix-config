{ inputs, config, pkgs, libs, ... }:

{

  environment.systemPackages = with pkgs; [
    mergerfs
    mergerfs-tools
    exfatprogs
    fuse

    snapraid
  ];

  # Mergerfs section
  programs.fuse.userAllowOther = true;

  # This fixes the weird mergerfs permissions issue
  boot.initrd.systemd.enable = true;
  
  # Snapraid section
  services.snapraid = {
    enable = true;
    parityFiles = [
      "/mnt/parity1/snapraid.parity"
    ];
    contentFiles = [
      "/mnt/data1/snapraid.content"
      "/mnt/data2/snapraid.content"
      "/mnt/data3/snapraid.content"
    ];

    # List mergerfs drives as dataDisks
    dataDisks = {
      d1 = "/mnt/data1/";
      d2 = "/mnt/data2/";
      d3 = "/mnt/data3/";
    };

    # List folders and filetypes not to sync
    exclude = [
      "*.unrecoverable"
      "/tmp/"
      "/lost-found/"
      "/.snapshots/"
      # "/Media/"
    ];
  };

  # Snapraid Systemd Services

  systemd.services.snapraid-sync = {
    serviceConfig = {
      RestrictNamespaces = lib.mkForce false;
      RestrictAddressFamilies = lib.mkForce "";
    };
    postStop = ''
    if [[ $SERVICE_RESULT =~ "success" ]]; then
      message=""
    else
      message=$(journalctl --unit=snapraid-sync.service -n 20 --no-pager)
    fi
    /run/current-system/sw/bin/notify -s "$SERVICE_RESULT" -t "Snapraid Sync" -m "$message"
    '';
  };

  systemd.services.snapraid-scrub = {
    serviceConfig = {
      RestrictAddressFamilies = lib.mkForce "";
    };
    postStop = ''
    if [[ $SERVICE_RESULT =~ "success" ]]; then
      message=""
    else
      message=$(journalctl --unit=snapraid-scrub.service -n 20 --no-pager)
    fi
    /run/current-system/sw/bin/notify -s "$SERVICE_RESULT" -t "Snapraid Scrub" -m "$message"
    '';
  };


  # Disk mounts

  fileSystems."/mnt/data1" =
    { device = "dev/disk/by-uuid/cfa67f8d-a663-425b-be1e-028c5a5f9c1b";
      fsType = "ext4";
      options = [ "defaults" ];
    };
  fileSystems."/mnt/data2" =
    { device = "dev/disk/by-uuid/3d133b0f-a465-4851-a97b-cbfffb1f899b";
      fsType = "ext4";
      options = [ "defaults" ];
    };
  fileSystems."/mnt/data3" =
    { device = "dev/disk/by-uuid/caf32c78-82df-40d3-8334-0ece5957a268";
      fsType = "ext4";
      options = [ "defaults" ];
    };
  fileSystems."/mnt/parity1" =
    { device = "dev/disk/by-uuid/9c049b92-8f4f-44ba-87cf-99b89cb57dce";
      fsType = "ext4";
      options = [ "defaults" ];
    };

  # Mergerfs section that makes the combined drive
  fileSystems."/mnt/user" =
    { device = "mnt/data*";
      fsType = "fuse.mergerfs";
      options = [ 
        "category.create=lfs"
        "defaults"
        "allow_other" 
        "fsname=user"
        "moveonenospc=1"
        "minfreespace=1M"
        "func.getattr=newest"
        "gid=993"
        "uid=994"
        "umask=002"
        "x-mount.mkdir"
      ];
    };
}
