# Ackerman's NixOS Packages

Zero-maintenance NixOS flake for **RootApp**, **OpenCode Desktop**, **Helium** and **ProtonPlus**.

## Packages

* `rootapp` — Root Field Service Management (AppImage)
* `opencode-desktop` — AI coding agent desktop client (.deb)
* `helium` — Private, fast, and honest web browser based on Chromium (tar.xz, x86_64 + aarch64)
* `protonplus` — Modern Wine/Proton compatibility tools manager (AppImage, x86_64 + aarch64)

## Features

* **Desktop Integration:** Ships proper `.desktop` entries and icons for Wayland/X11.
* **Zero-Maintenance:** GitHub Actions checks upstream daily and auto-updates versions and hashes.
* **Autonomous Maintainer:** An AI agent ([opencode-schedule](.github/workflows/opencode-schedule.yml)) runs every 6 hours — it verifies builds, audits dependencies, fixes packaging issues, and triages issues/PRs. It reports through [.opencode-relay.md](.opencode-relay.md), and can be invoked on demand by commenting `/oc` or `/opencode` on any issue or PR.

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
```
