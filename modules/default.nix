{ config, lib, ... }:

{
  options.custModules = {
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
    ./powermanagement
  ];
  config = lib.mkIf config.custModules.enable {
    users = {
      groups.${config.custModules.group} = {
	gid = 993;
      };
      users.${config.custModules.group} = {
        uid = 994;
        isSystemUser = true;
        group = config.custModules.group;
      };
    };
  };
}
