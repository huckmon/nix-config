{ inputs, config, pkgs, lib, ... }:

{

  environment.systemPackages = with pkgs; [
    snapraid
  ];

  # Snapraid section
  services.snapraid = {
    enable = true;
    parityFiles = [
      "/mnt/parity1/snapraid.parity"
    ];
    contentFiles = [
      "/mnt/data2/snapraid.content"
      "/mnt/data3/snapraid.content"
    ];

    # List mergerfs drives as dataDisks
    dataDisks = {
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

#  systemd.services.snapraid-sync = {
#    serviceConfig = {
#      RestrictNamespaces = lib.mkForce false;
#      RestrictAddressFamilies = lib.mkForce "";
#    };
#    postStop = ''
#    if [[ $SERVICE_RESULT =~ "success" ]]; then
#      message=""
#    else
#      message=$(journalctl --unit=snapraid-sync.service -n 20 --no-pager)
#    fi
#    /run/current-system/sw/bin/notify -s "$SERVICE_RESULT" -t "Snapraid Sync" -m "$message"
#    '';
#  };

#  systemd.services.snapraid-scrub = {
#    serviceConfig = {
#      RestrictAddressFamilies = lib.mkForce "";
#    };
#    postStop = ''
#    if [[ $SERVICE_RESULT =~ "success" ]]; then
#      message=""
#    else
#      message=$(journalctl --unit=snapraid-scrub.service -n 20 --no-pager)
#    fi
#    /run/current-system/sw/bin/notify -s "$SERVICE_RESULT" -t "Snapraid Scrub" -m "$message"
#    '';
#  };

}
