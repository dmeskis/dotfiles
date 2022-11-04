{
  description = "dylan's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { darwin, nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
    in {
      # HB 16" MacBook Pro 
      darwinConfigurations."HB-Dylan" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ ./darwin.nix ];
      };
      homeConfigurations."dylanmeskis@HB-Dylan.home" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [
          ./hosts/homebot-mbp/home.nix 
        ];
      };
      # Personal macbook
      darwinConfigurations."Dylans-MBP" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ ./darwin.nix ];
      };
      homeConfigurations."dylanmeskis@Dylans-MBP.home" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [
          ./hosts/personal-m1-mbp/home.nix
        ];
      };

    };
}
