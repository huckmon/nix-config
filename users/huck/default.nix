{ config, inputs, pkgs, ... }:

{

  users = {
    users = {
      huck = {
        isNormalUser = true;
        extraGroups = [ 
          "wheel"
          "users"
          "podman"
#          "networkmanager"
        ];
        group = "huck";
	# openssh.authorizedKeys.keys = [ ];
        # hashedPasswordFile = ;
      };
    };
    groups = {
      huck = {
        gid = 1000;
      };
    };
  };
}
