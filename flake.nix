{
  description = "Ackerman Packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system} = {
        
        # ==========================================
        # PACKAGE 1: ROOTAPP (Keep as AppImage)
        # ==========================================
        rootapp = let
          pname = "rootapp";
          version = "latest";
          src = pkgs.fetchurl {
            url = "https://installer.rootapp.com/installer/Linux/X64/Root.AppImage";
            hash = "sha256-BY8XlfG+EDcLZp6iuzhP3DDMLcB5HfMgrW+WOIVWz/g=";
          };
          appimageContents = pkgs.appimageTools.extractType2 { inherit pname version src; };
        in pkgs.appimageTools.wrapType2 {
          inherit pname version src;
          extraInstallCommands = ''
            install -m 444 -D ${appimageContents}/Root.png $out/share/icons/hicolor/256x256/apps/rootapp.png
            mkdir -p $out/share/applications
            cat > $out/share/applications/rootapp.desktop <<EOF
            [Desktop Entry]
            Type=Application
            Name=RootApp
            Exec=rootapp
            Icon=rootapp
            Categories=Utility;
            Terminal=false
            EOF
          '';
        };

        # ==========================================
        # PACKAGE 2: OPENCODE (Switched to .deb FHS)
        # ==========================================
        opencode = pkgs.stdenv.mkDerivation rec {
          pname = "opencode-desktop";
          version = "v1.17.13";
          
          src = pkgs.fetchurl {
            url = "https://github.com/anomalyco/opencode/releases/download/${version}/opencode-desktop-linux-amd64.deb";
            hash = "sha256-nNLwVibk64w7C76xP8mgh1VYeQp+iNPDzd+dsRoQVBo=";
          };

          nativeBuildInputs = with pkgs; [
            dpkg
            makeWrapper
            autoPatchelfHook
          ];

          # NixOS libraries
          buildInputs = with pkgs; [
            alsa-lib at-spi2-atk at-spi2-core atk cairo cups dbus expat fontconfig
            freetype gdk-pixbuf glib gtk3 libdrm libnotify libxkbcommon mesa nspr nss
            pango systemd xorg.libX11 xorg.libXScrnSaver xorg.libXcomposite xorg.libXcursor
            xorg.libXdamage xorg.libXext xorg.libXfixes xorg.libXi xorg.libXrandr xorg.libXrender
            xorg.libXtst xorg.libxcb xorg.libxkbfile xorg.libxshmfence
          ];

          unpackPhase = ''
            dpkg -x $src .
          '';

          installPhase = ''
            runHook preInstall
            
            # The .deb extracts 
            mkdir -p $out/bin $out/share
            cp -R opt/ $out/
            cp -R usr/share/* $out/share/

            # Dynamically locate the binary folder
            APP_DIR=$(find $out/opt -maxdepth 1 -mindepth 1 -type d)
            APP_BINARY=$(find "$APP_DIR" -maxdepth 1 -type f -executable | head -n 1)

            # Link the binary to $out/bin
            ln -s "$APP_BINARY" $out/bin/opencode-desktop

            # the Wayland flags
            wrapProgram $out/bin/opencode-desktop \
              --add-flags "--ozone-platform-hint=wayland --enable-features=WaylandWindowDecorations,UseOzonePlatform --enable-gpu-rasterization --enable-zero-copy"

            # provided .desktop file to use wrapped binary
            sed -i "s|Exec=.*|Exec=$out/bin/opencode-desktop %U|g" $out/share/applications/*.desktop

            runHook postInstall
          '';
        };

        default = self.packages.${system}.rootapp;
      };
    };
}
