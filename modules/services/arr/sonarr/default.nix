{ config, vars, lib, ... }:
let
  directories = [
    service = "sonarr";
    cfgServ = config.customModules.services.${service};
    cfg = config.customModules;
  ];
in
{
  options.cfgServ = {
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
