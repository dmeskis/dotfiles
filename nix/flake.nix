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

  outputs =
    {
      darwin,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      mkDarwin =
        module:
        darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [ module ];
        };

      mkHome =
        system: module:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ module ];
        };
    in
    {
      darwinConfigurations = {
        "DMESKIS-MBP" = mkDarwin ./hosts/homebot-mbp/darwin.nix; # current LocalHostName
        "Dylans-MacBook-Pro" = mkDarwin ./hosts/personal-m1-mbp/darwin.nix;
      };

      homeConfigurations = {
        "dylanmeskis@DMESKIS-MBP" = mkHome "aarch64-darwin" ./hosts/homebot-mbp/home.nix;
        "dylanmeskis" = mkHome "aarch64-darwin" ./hosts/personal-m1-mbp/home.nix;
      };

      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-tree;
    };
}
