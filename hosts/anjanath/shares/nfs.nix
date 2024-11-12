
{ users, config, pkgs, lib, ... }:

{
  fileSystems."/mnt/share" = {
    device = "/mnt/User/Media";
    options = [ "bind" ];
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /export/Media
    '';


}
