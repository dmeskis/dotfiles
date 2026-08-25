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
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # HB 16" MacBook Pro
      darwinConfigurations."HB-Dylan" = darwin.lib.darwinSystem {
        inherit system;
        modules = [ ./darwin.nix ];
      };
      homeConfigurations."dylanmeskis@HB-Dylan" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./hosts/homebot-mbp/home.nix ];
      };

      # Personal macbook
      darwinConfigurations."Dylans-MacBook-Pro" = darwin.lib.darwinSystem {
        inherit system;
        modules = [ ./darwin.nix ];
      };
      homeConfigurations."dylanmeskis" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./hosts/personal-m1-mbp/home.nix ];
      };
    };
}
