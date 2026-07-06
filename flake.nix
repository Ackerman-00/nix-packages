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

          buildInputs = with pkgs; [
            alsa-lib at-spi2-atk at-spi2-core atk cairo cups dbus expat fontconfig
            freetype gdk-pixbuf glib gtk3 libdrm libnotify libxkbcommon mesa nspr nss
            pango systemd libx11 libxscrnsaver libxcomposite libxcursor
            libxdamage libxext libxfixes libxi libxrandr libxrender
            libxtst libxcb libxkbfile libxshmfence
          ];

          autoPatchelfIgnoreMissingDeps = [
            "libc.musl-x86_64.so.1"
          ];

          unpackPhase = ''
            dpkg -x $src .
          '';

          installPhase = ''
            runHook preInstall
            
            mkdir -p $out/bin $out/share
            cp -R opt/ $out/
            cp -R usr/share/* $out/share/

            find $out/opt -type d -name "*musl*" -exec rm -rf {} + 2>/dev/null || true

            APP_DIR=$(find $out/opt -maxdepth 1 -mindepth 1 -type d)
            APP_BINARY=$(find "$APP_DIR" -maxdepth 1 -type f -executable | head -n 1)

            ln -s "$APP_BINARY" $out/bin/opencode-desktop

            wrapProgram $out/bin/opencode-desktop \
              --add-flags "--ozone-platform-hint=wayland --enable-features=WaylandWindowDecorations,UseOzonePlatform --enable-gpu-rasterization --enable-zero-copy"

            sed -i "s|Exec=.*|Exec=$out/bin/opencode-desktop %U|g" $out/share/applications/*.desktop

            runHook postInstall
          '';
        };

        default = self.packages.${system}.rootapp;
      };
    };
}
