## Packages

* `rootapp` — Root Field Service Management (AppImage, x86_64 + aarch64)
* `zen-browser` — Beautifully designed, privacy-focused Firefox fork (tar.xz, x86_64 + aarch64)
* `niri-unstable` — Scrollable-tiling Wayland compositor, latest upstream commit (source build, x86_64; binary via our cache below)
* `xwayland-satellite-unstable` — Rootless Xwayland integration, latest upstream commit (source build, x86_64; binary via our cache below)
* `mixtapes` — Modern, Linux-first YouTube Music player built with GTK4 and Libadwaita (source, x86_64 + aarch64)
* `splayer-next` — Cross-platform desktop music player with rich lyric support (tar.gz, x86_64 + aarch64)

---

## How to Add it to your NixOS System

### 1. Add the Input

Open your system's `flake.nix` and add this repository to your `inputs` block:

```nix
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Add Ackerman's Packages Flake
    nix-packages = {
      url = "github:Ackerman-00/nix-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

```

### 2. Install the Packages

Pass the inputs to your system configuration and add the desired applications to your `environment.systemPackages`:

```nix
  outputs = { self, nixpkgs, ... } @ inputs: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        
        ({ pkgs, inputs, ... }: {
          environment.systemPackages = [
            # Add the packages here
            inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.rootapp
            inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser
            inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable
            inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.xwayland-satellite-unstable
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
```

## Binary cache (free, no Cachix)

Every CI-built rev of the `-unstable` source packages is signed and published
to the rolling `nixcache` release on this repo (same pattern as void-nexus).
Add it once — `flake update` then fetches binaries, never compiles:

```nix
nix.settings = {
  substituters = [ "https://github.com/Ackerman-00/nix-packages/releases/download/nixcache" ];
  trusted-public-keys = [ "nixcache:5i/lXrpYqlfr2c6eNC6aieaaS8CvZMzDbGB2dhlz3qI=" ];
};
```
nix run github:Ackerman-00/nix-packages#mixtapes
nix run github:Ackerman-00/nix-packages#splayer-next
```
