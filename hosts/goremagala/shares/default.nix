{ users, config, pkgs, lib, vars, ... }:
let
  smb = {
    share_list = {
      # needs to be rewritten to use path variable
      "Media" = { "path" = "/mnt/user/Media"; };
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

  options.customModules.samba = {
    enable = lib.mkEnableOption "enable samba shares for machine";
    commonSettings = lib.mkOption {
      description = "parameters applied to each share";
    };
    #globalSettings = lib.mkOption {
    #  description = "global samba params";
    #  default = { };
    #  example = { };	
    #};
  };

  config = lib.mkIf config.customModules.samba.enable {
  # make shares visible for windows 10 clients
    services.samba-wsdd.enable = true;

#  users = {
#  groups.share = {
#    gid = 993;
#  };

#  users.share = {
#    uid = 994;
#    isSystemUser = true;
#    group = "share";
#    };
#  };


#  users = {
#    share = {
#      uid = 994;
#      isSystemUser = true;
#      group = "share";
#    };
#    groups.share.gid = 993;
#  };

    environment.systemPackages = with pkgs; [
      samba
      avahi
    ];

    systemd.tmpfiles.rules = map (x: "d ${x.path} 0775 ${config.customModules.user} ${config.customModules.group} - -") (lib.attrValues smb.share_list);

    services.samba = {
      enable = true;
      nmbd.enable = true;
      openFirewall = true;
      settings = {
	global = {
          workgroup = "WORKGROUP";
          "server string"  = "goremagala";
          "netbios name" = "goremagala";
          "hosts allow" = "192.168.60.0/24 192.168.20.0/24";
          "guest account" = "nobody";
          "map to guest" = "bad user";
          "security" = "user";
          "invalid users" = [ "root" ];
        };
        "Media" = { #share_params;
	  "path" = "/mnt/user/Media";
          "browseable" = "yes";
          "writeable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "2775";
          "valid users" = "share";
	};
      }; # // builtins.mapAttrs (name: value: value // smb.share_params) smb.share_list;
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
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
  };
}
