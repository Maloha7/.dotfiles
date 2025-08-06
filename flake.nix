{
  description = "Nixos Flake Config";

  inputs = {
	nixpkgs.url = "nixpkgs/nixos-25.05";
    catppuccin.url = "github:catppuccin/nix/release-25.05";
	home-manager.url = "github:nix-community/home-manager/release-25.05";
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
			modules = [./home.nix  catppuccin.homeModules.catppuccin];
		};
	};
  };

}
