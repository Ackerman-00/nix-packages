# nix-packages

Nix flake with packages nixpkgs trails behind on: prebuilt binaries plus
rev-pinned source builds, all with a free binary cache.

## Packages

| package | type |
|---|---|
| `rootapp` | AppImage (x86_64 + aarch64) |
| `zen-browser` | tarball (x86_64 + aarch64) |
| `niri-unstable` | latest upstream commit, source-built |
| `xwayland-satellite-unstable` | latest upstream commit, source-built |
| `umbriel-unstable` | latest upstream commit, source-built |
| `xdg-desktop-portal-umbriel-unstable` | umbriel's portal backend (screencast/sharing), latest commit |
| `mixtapes` | source-built (x86_64 + aarch64) |
| `splayer-next` | tarball (x86_64 + aarch64) |

Install `xwayland-satellite-unstable` alongside a compositor for X11 apps
(upstream contract: discovered on PATH at runtime, never bundled).

Compositors need `services.displayManager.sessionPackages` to appear in
login managers — plain `environment.systemPackages` is not scanned.

## Use

```nix
inputs.nix-packages.url = "github:Ackerman-00/nix-packages";
```

```nix
outputs = { self, nixpkgs, ... } @ inputs: {
  nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      ./configuration.nix

      ({ pkgs, inputs, ... }: {
        environment.systemPackages = [
          inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.rootapp
          inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser
          inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable
          inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.xwayland-satellite-unstable
          inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.umbriel-unstable
          inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-umbriel-unstable
          inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.mixtapes
          inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.splayer-next
        ];
      })
    ];
  };
};
```

## Run Without Installing

```bash
nix run github:Ackerman-00/nix-packages#rootapp
nix run github:Ackerman-00/nix-packages#zen-browser
nix run github:Ackerman-00/nix-packages#niri-unstable
nix run github:Ackerman-00/nix-packages#xwayland-satellite-unstable
nix run github:Ackerman-00/nix-packages#umbriel-unstable
nix run github:Ackerman-00/nix-packages#xdg-desktop-portal-umbriel-unstable
nix run github:Ackerman-00/nix-packages#mixtapes
nix run github:Ackerman-00/nix-packages#splayer-next
```

## Binary cache

Signed rolling release `nixcache`; per-package `manifest-<pkg>.txt`
indexes. Old revs are garbage-collected automatically.

```nix
nix.settings = {
  substituters = [ "https://github.com/Ackerman-00/nix-packages/releases/download/nixcache" ];
  trusted-public-keys = [ "nixcache:5i/lXrpYqlfr2c6eNC6aieaaS8CvZMzDbGB2dhlz3qI=" ];
};
```
