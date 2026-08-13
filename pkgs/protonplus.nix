{ pkgs, lib }:

let
  pname = "protonplus";
  version = "0.6.4";

  archives = {
    x86_64-linux = pkgs.fetchurl {
      url = "https://github.com/Vysp3r/ProtonPlus/releases/download/v${version}/ProtonPlus-${version}-anylinux-x86_64.AppImage";
      hash = "sha256-J0ddq9hoIb7QeNLQiEEN8qDqr/iFylrwAqxhIQX++Qs=";
    };
    aarch64-linux = pkgs.fetchurl {
      url = "https://github.com/Vysp3r/ProtonPlus/releases/download/v${version}/ProtonPlus-${version}-anylinux-aarch64.AppImage";
      hash = "sha256-o4sUkr3JJWRxhOzCRsPUjqJNQTgtHBaW7xw9MpmhCBo=";
    };
  };

  src = archives.${pkgs.stdenv.hostPlatform.system};
in pkgs.stdenv.mkDerivation {
  inherit pname version src;

  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    cp $src ./protonplus.AppImage
    chmod +x ./protonplus.AppImage
    ./protonplus.AppImage --appimage-extract
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/applications \
      $out/share/icons/hicolor/256x256/apps

    # sharun-based AppImage; the bun-compiled binary resolves ../shared,
    # ../lib, ../share and ../etc relative to itself, so install the full bundle
    cp -r squashfs-root/bin $out/
    cp -r squashfs-root/shared $out/
    cp -r squashfs-root/lib $out/
    cp -r squashfs-root/share $out/
    cp -r squashfs-root/etc $out/
    install -m 644 squashfs-root/com.vysp3r.ProtonPlus.desktop \
      $out/share/applications/
    install -m 644 squashfs-root/com.vysp3r.ProtonPlus.png \
      $out/share/icons/hicolor/256x256/apps/com.vysp3r.ProtonPlus.png
    runHook postInstall
  '';

  installCheckPhase = ''
    $out/bin/protonplus version >/dev/null
  '';

  meta = {
    homepage = "https://github.com/Vysp3r/ProtonPlus";
    description = "A modern compatibility tools manager for Linux";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "protonplus";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
