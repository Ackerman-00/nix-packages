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

        opencode = let
          pname = "opencode-desktop";
          version = "v1.17.13";
          src = pkgs.fetchurl {
            url = "https://github.com/anomalyco/opencode/releases/download/${version}/opencode-desktop-linux-x86_64.AppImage";
            hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          };
          appimageContents = pkgs.appimageTools.extractType2 { inherit pname version src; };
        in pkgs.appimageTools.wrapType2 {
          inherit pname version src;
          extraInstallCommands = ''
            if [ -f ${appimageContents}/.DirIcon ]; then
              install -m 444 -D ${appimageContents}/.DirIcon $out/share/icons/hicolor/256x256/apps/opencode.png
            fi
            mkdir -p $out/share/applications
            cat > $out/share/applications/opencode.desktop <<EOF
            [Desktop Entry]
            Type=Application
            Name=Opencode
            Exec=opencode-desktop
            Icon=opencode
            Categories=Development;
            Terminal=false
            EOF
          '';
        };

        default = self.packages.${system}.rootapp;
      };
    };
}
