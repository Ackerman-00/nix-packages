# Ackerman's NixOS Packages

Zero-maintenance NixOS flake for **RootApp** and **OpenCode Desktop**.

## Packages

* `rootapp` — Root Field Service Management (AppImage)
* `opencode-desktop` — AI coding agent desktop client (.deb)

## Features

* **Desktop Integration:** Ships proper `.desktop` entries and icons for Wayland/X11.
* **Zero-Maintenance:** GitHub Actions checks upstream daily and auto-updates versions and hashes.

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
```
