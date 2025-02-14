{ config, vars, lib, ... }:
let
  service = "prowlarr";
  cfgServ = config.customModules.services.${service};
  cfg = config.customModules;
in
{
  options.customModules.services.${service} = {
    enable = lib.mkEnableOption "Enable ${service} service";
    configDir = lib.mkOption {
      default = "var/lib/${service}";
    };
  };

  config = lib.mkIf cfg.enable {
    services.${service} = {
      enable = true;
      user = cfg.user;
      group = cfg.group;
      openFirewall = true;
    };
  };
}
