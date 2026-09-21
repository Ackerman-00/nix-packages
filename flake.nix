{
  description = "Ackerman Packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      lib = nixpkgs.lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          # rootapp is inherently unfree (proprietary); importing nixpkgs
          # with allowUnfree lets this flake ship it without forcing every
          # consumer to set nixpkgs.config.allowUnfree themselves.
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };
          zen-browser = pkgs.callPackage ./pkgs/zen-browser.nix { inherit lib; };
          rootapp = pkgs.callPackage ./pkgs/rootapp.nix { inherit lib; };
          mixtapes = pkgs.callPackage ./pkgs/mixtapes.nix { inherit lib; };
          splayer-next = pkgs.callPackage ./pkgs/splayer-next.nix { inherit lib; };
          xwayland-satellite-unstable = pkgs.callPackage ./pkgs/xwayland-satellite-unstable.nix {
            inherit lib;
          };
          niri-unstable = pkgs.callPackage ./pkgs/niri-unstable.nix {
            inherit lib;
            xwayland-satellite-unstable = xwayland-satellite-unstable;
          };
        in
        {
          zen-browser = zen-browser;
          rootapp = rootapp;
          mixtapes = mixtapes;
          splayer-next = splayer-next;
          xwayland-satellite-unstable = xwayland-satellite-unstable;
          niri-unstable = niri-unstable;
        }
        // lib.optionalAttrs (system == "x86_64-linux") {
          default = self.packages.${system}.rootapp;
        }
        // lib.optionalAttrs (system == "aarch64-linux") {
          default = zen-browser;
        }
      );
    };
}
