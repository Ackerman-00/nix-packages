{
  description = "Ackerman Packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      lib = nixpkgs.lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = lib.genAttrs systems;
    in {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          helium = pkgs.callPackage ./pkgs/helium.nix { inherit lib; };
          protonplus = pkgs.callPackage ./pkgs/protonplus.nix { inherit lib; };
        in {
          helium = helium;
          protonplus = protonplus;
        } // lib.optionalAttrs (system == "x86_64-linux") {
          rootapp = pkgs.callPackage ./pkgs/rootapp.nix { inherit lib; };
          opencode-desktop = pkgs.callPackage ./pkgs/opencode-desktop.nix { inherit lib; };
          default = self.packages.${system}.rootapp;
        } // lib.optionalAttrs (system == "aarch64-linux") {
          default = helium;
        });
    };
}