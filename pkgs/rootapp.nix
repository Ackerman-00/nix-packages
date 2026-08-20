{ pkgs, lib }:

let
  pname = "rootapp";
  version = "latest";

  archives = {
    x86_64-linux = pkgs.fetchurl {
      url = "https://installer.rootapp.com/installer/Linux/X64/Root.AppImage";
      hash = "sha256-LFTZZC9qhHdRgQXzNa6j74hNn8oxjIR/J+bTM0DB3Js=";
    };
    aarch64-linux = pkgs.fetchurl {
      url = "https://installer.rootapp.com/installer/Linux/Arm64/Root.AppImage";
      hash = "sha256-zGjAfI04zb1VE8zAtPMZ2gzUcvCwWlz9X8LV/dpUUk4=";
    };
  };

  src = archives.${pkgs.stdenv.hostPlatform.system};
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
  meta = {
    homepage = "https://rootapp.com";
    description = "Root Field Service Management";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    mainProgram = "rootapp";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
