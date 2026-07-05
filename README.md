# 🚀 Ackerman's NixOS Packages

A pure, zero-maintenance NixOS flake for installing and running custom AppImages like **RootApp** and **Opencode Desktop**.

## 📦 Available Packages

* `rootapp` - Root Field Service Management
* `opencode` - Opencode Desktop Application

## ✨ Features

* **Completely Pure:** No mutable files in `/var/lib/` or background downloads on your local machine.
* **Desktop Integration:** Automatically extracts the native official logos from the AppImages and installs fully functional `.desktop` entries for your Wayland/X11 compositor or DE.
* **Zero-Maintenance:** A GitHub Actions workflow automatically checks upstream APIs and URLs daily, automatically updating the flake versions and hashes when new updates drop.

---

## 🛠️ How to Add it to your NixOS System

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

Pass the input to your system configuration and add the desired applications to your `environment.systemPackages`:

```nix
  outputs = { self, nixpkgs, ackerman-packages, ... }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        
        ({ pkgs, ... }: {
          environment.systemPackages = [
            # Add the packages here
            inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.rootapp
            inputs.nix-packages.packages.${pkgs.stdenv.hostPlatform.system}.opencode
          ];
        })
      ];
    };
  };

```

---

## 🏃 Run Without Installing

You can test or run these applications directly from the terminal without permanently adding them to your system configuration:

```bash
# Run RootApp
nix run github:Ackerman-00/nix-packages#rootapp

# Run Opencode
nix run github:Ackerman-00/nix-packages#opencode

```
