{ config, vars, lib, ... }:
#let
  #directories = [
    #"${vars.serviceConfigRoot}/vaultwarden"
  #];

#in
let
  service = "vaultwarden";
  cfg = config.customModules.services.${service};
in
{

  options.customModules.services.${service} = {
    enable = lib.mkEnableOption "Enable ${service} service";
  };

  config = lib.mkIf cfg.enable {

    #systemd.tmpfiles.rules = map (x: "d ${x} 0775 share share - -") directories;
    virtualisation.oci-containers = {
      containers = {
        vaultwarden = {
          image = "vaultwarden/server:latest";
          autoStart = true;
          volumes = [
            "/home/vw-data:/data"
          ];
          ports = [
            "9395:80"
          ];
        };
      };
    };
  };

}
