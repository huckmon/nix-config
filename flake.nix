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
      specialArgs = {inherit inputs;};
      modules = [
#        ./hosts/anjanath/test.nix
	./hosts/anjanath/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
