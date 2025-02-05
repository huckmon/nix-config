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
