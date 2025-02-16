{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: 
  let
    system = "x86_64-linux";
    pkgs  = nixpkgs.legacyPackages.${system};
  in
  {
    nixosConfigurations.anjanath = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        vars = import ./hosts/anjanath/vars.nix; # handles custom variables from var file
      };
      modules = [
	./hosts/anjanath/configuration.nix
	./users/huck
        #inputs.home-manager.nixosModules.default
      ];
    };

    nixosConfigurations.goremagala = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        vars = import ./hosts/anjanath/vars.nix; # handles custom variables from var file
      };
      modules = [
	./hosts/goremagala/configuration.nix
	./users/huck
        #inputs.home-manager.nixosModules.default
      ];
    };

  };
}
