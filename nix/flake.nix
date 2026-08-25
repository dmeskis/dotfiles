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

      # darwin.nix is currently host-independent, so every machine shares it.
      mkDarwin = darwin.lib.darwinSystem {
        inherit system;
        modules = [ ./darwin.nix ];
      };

      mkHome = module: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ module ];
      };
    in {
      darwinConfigurations = {
        "DMESKIS-MBP" = mkDarwin; # work, current LocalHostName
        "Dylans-MacBook-Pro" = mkDarwin; # personal
      };

      homeConfigurations = {
        "dylanmeskis@DMESKIS-MBP" = mkHome ./hosts/homebot-mbp/home.nix;
        "dylanmeskis" = mkHome ./hosts/personal-m1-mbp/home.nix;
      };
    };
}
