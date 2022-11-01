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

  outputs = { darwin, nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      # pkgs = nixpkgs.legacyPackages.${system};
    in {
      # HB 16" MacBook Pro 
      darwinConfigurations."MacBook-Pro" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ ./darwin.nix ];
      };
      # Personal macbook
      darwinConfigurations."Dylans-MBP" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ ./darwin.nix ];
      };
      homeConfigurations.dylanmeskis = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}

