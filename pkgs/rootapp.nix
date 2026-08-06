{ pkgs, lib }:

let
  pname = "rootapp";
  version = "latest";
  src = pkgs.fetchurl {
    url = "https://installer.rootapp.com/installer/Linux/X64/Root.AppImage";
    hash = "sha256-BzaSb96SOBnSdqxtSjr+ZcbYfHNGia9HJ2/E6/B12RA=";
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
}
