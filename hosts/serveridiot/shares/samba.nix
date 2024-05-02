{ users, config, pkgs, lib, ... }:

  #samba
let
  smb = {
    share_list = {
      Backups = { path = "mnt/user/Backup"; };
      Documents = { path = "mnt/user/Documents"; };
      Media = { path = "mnt/user/Media"; };
    };
    share_params = {
      "browseable" = "yes";
      "writeable" = "yes";
      "read only" = "no";
      "guest ok" = "no";
      "create mask" = "0644";
      "directory mask" = "2775";
      "valid users" = "share";
    };
  };
  smb_shares = builtins.mapAttrs (name: value: value // smb.share_params) smb.share_list;
in
{
services.samba-wsdd.enable = true; # make shares visible for windows 10 clients



users = {
groups.share = {
  gid = 993;
};
users.share = {
  uid = 994;
  isSystemUser = true;
  group = "share";
  };
};

#users.users.huck.extraGroups = [ "share" ];

#environment.systemPackages = [ config.services.samba.package ];

#environment.systemPackages = with pkgs; [
#  samba
#  avahi
#];

environment = {
  #systemPackages = [ config.services.samba.package ];
  systemPackages = with pkgs; [
    samba
    avahi
  ];
};

systemd.tmpfiles.rules = map (x: "d ${x.path} 0775 share share - -") (lib.attrValues smb.share_list) ++ ["d /mnt 0775 share share - -"];
#systemd.tmpfiles.rules = [
   # "d /mnt/user/Backups 0775 share share - -"
   # "d /mnt/user/Documents 0775 share share - -"
   # "d /mnt/user/Media 0775 share share - -"
 # ];
  services.samba = {
    enable = true;
    #enableNmbd = true;
    openFirewall = true;
    invalidUsers = [ "root" ];
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = serveridiot
      netbios name = serveridiot
      security = user 
      hosts allow = 192.168.60.0/24 #192.168.20.0/24
      guest account = nobody
      map to guest = bad user
      '';
    shares = smb_shares; #{
#      Backups = { 
#        path = "/mnt/user/Backups"; 
#        "browseable" = "yes";
#        "writeable" = "yes";
#        "read only" = "no";
#        "guest ok" = "no";
#        "create mask" = "0644";
#        "directory mask" = "0755";
#        "valid users" = "share";
#      };
#      Documents = { 
#        path = "/mnt/user/Documents";
#        "browseable" = "yes";
#        "writeable" = "yes";
#        "read only" = "no";
#        "guest ok" = "no";
#        "create mask" = "0644";
#        "directory mask" = "0755";
#        "valid users" = "share";
#      };
#      Media = { 
#        path = "/mnt/user/Media"; 
#        "browseable" = "yes";
#        "writeable" = "yes";
#        "read only" = "no";
#        "guest ok" = "no";
#        "create mask" = "0644";
#        "directory mask" = "0755";
#        "valid users" = "share";
#      };
#      Misc = { 
#        path = "/mnt/user/Misc"; 
#        "browseable" = "yes";
#        "writeable" = "yes";
#        "read only" = "no";
#        "guest ok" = "no";
#        "create mask" = "0644";
#        "directory mask" = "0755";
#        "valid users" = "share";
#      };
#    };
  };
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
    extraServiceFiles = {
      smb = ''
        <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
        <name replace-wildcards="yes">%h</name>
        <service>
        <type>_smb._tcp</type>
        <port>445</port>
        </service>
        </service-group>
        '';
    };
  };
}
