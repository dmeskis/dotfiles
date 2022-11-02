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
      lib = nixpkgs.lib;
      config = nixpkgs.config;
    in {
      # HB 16" MacBook Pro 
      darwinConfigurations."HB-Dylan" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ ./darwin.nix ];
      };
      # Personal macbook
      darwinConfigurations."Dylans-MBP" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ ./darwin.nix ];
      };

      homeConfigurations.dylanmeskis = home-manager.lib.homeManagerConfiguration {
        inherit lib;
        # inherit config;
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [
          (lib.mkIf (config.networking.hostName == "HB-Dylan" )( ./hosts/homebot-mbp/home.nix ))
          (lib.mkIf (config.networking.hostName == "Dylans-MBP") ( ./hosts/personal-m1-mbp/home.nix))
        ];
        # modules = [ ./home.nix ];
      };
    };
}

