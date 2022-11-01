{
  description = "dylan's config";

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

  outputs = { darwin, home-manager, nixpkgs, ... }:
    let
      darwinARMSystem = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager {
            home-manager.users.dylanmeskis = homeManagerConfFor ./home.nix
          }
        ];
        specialArgs = { inherit nixpkgs; };
      },
    in {
      defaultPackage.aarch64-darwin = darwinARMSystem.system;
    };
}

