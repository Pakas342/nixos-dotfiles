
{

  description = "System flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  let 
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      laptop = lib.nixosSystem {
        system = "x86_64-linux";
	modules = [ ./hosts/laptop/configuration.nix ];
      };
    };
  };

}
