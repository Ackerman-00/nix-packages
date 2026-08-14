{ pkgs, lib }:

let
  pname = "helium";
  version = "0.15.4.1";

  archives = {
    x86_64-linux = pkgs.fetchurl {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64_linux.tar.xz";
      hash = "sha256-qx92G2VWfd3QYr0EYtNCoJlNfGOAvh71cQuFE5A8Hzw=";
    };
    aarch64-linux = pkgs.fetchurl {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-arm64_linux.tar.xz";
      hash = "sha256-JTdAxJAIp22cpPRzay3DWpD6TvF0N9N0h0Zqrah+1uQ=";
    };
  };

  runtimeDeps = with pkgs; [
    stdenv.cc.cc.lib
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libx11
    libGL
    libxkbcommon
    libxscrnsaver
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxshmfence
    libxtst
    libuuid
    libgbm
    nspr
    nss
    pango
    pipewire
    udev
    wayland
    libxcb
    zlib
    snappy
    libkrb5
    qt5.qtbase
    qt6.qtbase
    libpulseaudio
    libva
  ];

  rpath = lib.makeLibraryPath runtimeDeps;
in
pkgs.stdenv.mkDerivation {
  inherit pname version;

  src = archives.${pkgs.stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;

  nativeBuildInputs = with pkgs; [
    patchelf
    makeWrapper
    # Use shell wrapper so gappsWrapperArgs can evaluate ${NIXOS_OZONE_WL}
    (wrapGAppsHook3.override { makeWrapper = makeShellWrapper; })
  ];

  buildInputs = with pkgs; [
    glib
    gsettings-desktop-schemas
    gtk3
    adwaita-icon-theme
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/helium $out/share/applications $out/share/metainfo \
             $out/share/icons/hicolor/256x256/apps

    cp -r . $out/opt/helium/

    # NixOS has no /bin/sh, so fix the wrapper shebang and mark the distro
    substituteInPlace $out/opt/helium/helium-wrapper \
      --replace-fail '#!/bin/sh' '#!${pkgs.stdenv.shell}' \
      --replace-fail 'CHROME_VERSION_EXTRA="custom"' 'CHROME_VERSION_EXTRA="nixos"'

    # The bundled binaries were built on Debian and expect /lib64/ld-linux
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/opt/helium/helium $out/opt/helium/helium_crashpad_handler $out/opt/helium/chromedriver

    # Upstream wrapper resolves itself via readlink and sets LD_LIBRARY_PATH
    ln -s $out/opt/helium/helium-wrapper $out/bin/helium

    # Desktop entry, icon and AppStream metadata
    install -m 644 $out/opt/helium/helium.desktop $out/share/applications/
    rm $out/opt/helium/helium.desktop
    install -m 644 $out/opt/helium/product_logo_256.png \
      $out/share/icons/hicolor/256x256/apps/helium.png

    cat > $out/share/metainfo/net.imput.helium.metainfo.xml <<EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <component type="desktop-application">
      <id>net.imput.helium</id>
      <launchable type="desktop-id">helium.desktop</launchable>
      <metadata_license>CC0-1.0</metadata_license>
      <project_license>GPL-3.0-only</project_license>
      <name>Helium</name>
      <summary>Private, fast, and honest web browser</summary>
      <description>
        <p>Helium is a private, fast, and honest web browser based on Chromium.
        It prioritizes user privacy while maintaining excellent performance and
        a clean browsing experience.</p>
      </description>
      <url type="homepage">https://github.com/imputnet/helium-linux</url>
      <releases>
        <release version="${version}" />
      </releases>
      <developer id="net.imput">
        <name>imput</name>
      </developer>
    </component>
    EOF

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${rpath}
      --suffix PATH : ${lib.makeBinPath [ pkgs.xdg-utils ]}
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto}}"
    )
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/helium --version
  '';

  meta = {
    homepage = "https://github.com/imputnet/helium-linux";
    description = "Private, fast, and honest web browser based on Chromium";
    license = with lib.licenses; [ gpl3Plus bsd3 ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.linux;
    mainProgram = "helium";
  };
}