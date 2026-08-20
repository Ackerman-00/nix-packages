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
          # rootapp is inherently unfree (proprietary); importing nixpkgs
          # with allowUnfree lets this flake ship it without forcing every
          # consumer to set nixpkgs.config.allowUnfree themselves.
          pkgs = import nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
          };
          helium = pkgs.callPackage ./pkgs/helium.nix { inherit lib; };
          protonplus = pkgs.callPackage ./pkgs/protonplus.nix { inherit lib; };
          zen-browser = pkgs.callPackage ./pkgs/zen-browser.nix { inherit lib; };
          opencode-desktop = pkgs.callPackage ./pkgs/opencode-desktop.nix { inherit lib; };
          rootapp = pkgs.callPackage ./pkgs/rootapp.nix { inherit lib; };
        in {
          helium = helium;
          protonplus = protonplus;
          zen-browser = zen-browser;
          opencode-desktop = opencode-desktop;
          rootapp = rootapp;
        } // lib.optionalAttrs (system == "x86_64-linux") {
          default = self.packages.${system}.rootapp;
        } // lib.optionalAttrs (system == "aarch64-linux") {
          default = helium;
        });
    };
}