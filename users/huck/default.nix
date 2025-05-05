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
          "networkmanager"
        ];
	# openssh.authorizedKeys.keys = [ ];
        # hashedPasswordFile = ;
      };
    };
    #groups = {
    #  huck = {
    #    gid = ;
    #  };
    #};
  };
}
