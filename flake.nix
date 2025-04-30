{
  description = "Nixos config flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-normal.url = "github:nixos/nixpkgs/nixos-unstable"
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
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
        ./hosts/anjanath
        ./users/huck
      ];
    };

    nixosConfigurations.goremagala = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        vars = import ./hosts/goremagala/vars.nix;
      };
      modules = [
        ./hosts/goremagala
        ./users/huck
      ];
    };

    nixosConfigurations.greatjaggi = nixpkgs-normal.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        vars = import ./hosts/greatjaggi/vars.nix;
      };
      modules = [
        ./hosts/greatjaggi
        ./users/huck
        inputs.home-manager.nixosModules.default
        inputs.nixos-heardware.nixosModules.framework-13th-gen-intel
      ];
    };

  };
}
