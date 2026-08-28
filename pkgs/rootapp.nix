{ pkgs, lib }:

let
  pname = "rootapp";
  version = "0.9.127";

  archives = {
    x86_64-linux = pkgs.fetchurl {
      url = "https://installer.rootapp.com/installer/Linux/X64/Root.AppImage";
      hash = "sha256-aX6A504GqV53lFszx/txTVhALNQ/I3pEMzbqBbqofMI=";
    };
    aarch64-linux = pkgs.fetchurl {
      url = "https://installer.rootapp.com/installer/Linux/Arm64/Root.AppImage";
      hash = "sha256-JOtQcoBBZbBBcQXcxYS8BYqorhGOlsT1Qr8SRpEtG0Y=";
    };
  };

  src = archives.${pkgs.stdenv.hostPlatform.system};
  appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
in
pkgs.appimageTools.wrapType2 {
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
    maintainers = [
      {
        name = "Ackerman-00";
        github = "Ackerman-00";
      }
    ];
  };
}
