{ config, lib,... }:
let
  cfg = config.customModules;
in
{
  options.customModules = {
    enable = lib.mkEnableOption "Enables custom modules and configuration variables";
    user = lib.mkOption {
      default = "share";
      description = ''
	User to run homelab modules as
      '';
    };
    group = lib.mkOption {
      default = "share";  
      description = ''
        Group to run homelab modules as
      '';
    };
  };

  imports = [
    #./duckdns
    #./motd
    ./powermanagement
  ];
  config = lib.mkIf cfg.enable {
    users = {
      groups.${config.customModules.group} = {
        gid = 993;
      };
      users.${config.customModules.group} = {
        uid = 994;
        isSystemUser = true;
        group = config.customModules.group;
      };
    };
  };
}
