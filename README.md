## Packages

* `rootapp` — Root Field Service Management (AppImage, x86_64 + aarch64)
* `opencode-desktop` — AI coding agent desktop client (.deb, x86_64 + aarch64)
* `helium` — Private, fast, and honest web browser based on Chromium (tar.xz, x86_64 + aarch64)
* `protonplus` — Modern Wine/Proton compatibility tools manager (AppImage, x86_64 + aarch64)
* `zen-browser` — Beautifully designed, privacy-focused Firefox fork (tar.xz, x86_64 + aarch64)
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
            inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.opencode-desktop
            inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.helium
            inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.protonplus
            inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser
            inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.mixtapes
          ];
        })
      ];
    };
  };

```

## Run Without Installing

```bash
nix run github:Ackerman-00/nix-packages#rootapp
nix run github:Ackerman-00/nix-packages#opencode-desktop
nix run github:Ackerman-00/nix-packages#helium
nix run github:Ackerman-00/nix-packages#protonplus
nix run github:Ackerman-00/nix-packages#zen-browser
nix run github:Ackerman-00/nix-packages#mixtapes
```
