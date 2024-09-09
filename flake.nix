{
  description = "Nixos Flake Config";

  inputs = {
	nixpkgs.url = "nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
	home-manager.url = "github:nix-community/home-manager";
	home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, catppuccin, home-manager, ... }:
	let
	  lib = nixpkgs.lib;
	  system = "x86_64-linux";
	  pkgs = nixpkgs.legacyPackages.${system};
	  in {
  	nixosConfigurations = {
		nixos = lib.nixosSystem {
			inherit system;
			modules = [ ./configuration.nix ];
		};
	};
	homeConfigurations = {
		maloha = home-manager.lib.homeManagerConfiguration {
			inherit pkgs;
			modules = [ ./home.nix catppuccin.homeManagerModules.catppuccin ];
		};
	};
  };

}
