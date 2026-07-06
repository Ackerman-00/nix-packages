{
  description = "Ackerman Packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
    in {
      packages.${system} = {
        rootapp = pkgs.callPackage ./pkgs/rootapp.nix { inherit lib; };
        opencode-desktop = pkgs.callPackage ./pkgs/opencode-desktop.nix { inherit lib; };
        default = self.packages.${system}.rootapp;
      };
    };
}
