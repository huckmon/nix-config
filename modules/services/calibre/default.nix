{ config, vars, lib, ... }:
let
  service = "calibre";
  cfg = config.customModules.services.${service};
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
      user = config.customModules.user;
      group = config.customModules.group;
      openFirewall = true;
    };
  };
}
