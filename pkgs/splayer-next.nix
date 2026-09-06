{ pkgs, lib }:

let
  pname = "splayer-next";
  version = "1.1.0";

  archives = {
    x86_64-linux = pkgs.fetchurl {
      url = "https://github.com/SPlayer-Dev/SPlayer-Next/releases/download/v${version}/splayer-next-${version}-x64.tar.gz";
      hash = "sha256-rQlwOesWqZv5NHRcpTNUiQehVvn5X9Mq0J/ZA13Y8Zk=";
    };
    aarch64-linux = pkgs.fetchurl {
      url = "https://github.com/SPlayer-Dev/SPlayer-Next/releases/download/v${version}/splayer-next-${version}-arm64.tar.gz";
      hash = "sha256-ZWqszkA3Z9xMAZS080ZRtSYyXSmM/bd7UVUE1+tP83g=";
    };
  };

  # Union of the ELF NEEDED set (readelf -d on the main binary,
  # chrome_crashpad_handler, bundled .so and all 5 native .node modules)
  # and the upstream RPM's own Requires (libXtst, libuuid, libXScrnSaver,
  # libnotify are dlopen/helper deps invisible to NEEDED).
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
    glib
    gtk3
    libdrm
    libgbm
    libnotify
    libuuid
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxscrnsaver
    libxkbcommon
    libxtst
    nspr
    nss
    pango
    pipewire
    libpulseaudio
    udev
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
    copyDesktopItems
    # Use shell wrapper so gappsWrapperArgs can evaluate ${NIXOS_OZONE_WL}
    (wrapGAppsHook3.override { makeWrapper = makeShellWrapper; })
  ];

  buildInputs = with pkgs; [
    glib
    gsettings-desktop-schemas
    gtk3
    adwaita-icon-theme
  ];

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "splayer-next";
      desktopName = "SPlayer-Next";
      exec = "splayer-next %U";
      icon = "splayer-next";
      startupWMClass = "top.imsyy.splayer_next";
      comment = "Cross-platform desktop music player with rich lyric support";
      categories = [
        "AudioVideo"
        "Audio"
      ];
      mimeTypes = [ "x-scheme-handler/orpheus" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/splayer-next

    # Tarball has a single top-level dir; stdenv unpackPhase already cd'd
    # into it, so copy the app tree contents.
    cp -r . $out/opt/splayer-next/

    # The bundled binaries were built for FHS distros and expect
    # /lib64/ld-linux; repoint at the Nix dynamic linker.
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/opt/splayer-next/SPlayer-Next \
      $out/opt/splayer-next/chrome_crashpad_handler

    # Icon ships inside app.asar.unpacked (no top-level icon in tarball)
    install -Dm644 \
      $out/opt/splayer-next/resources/app.asar.unpacked/public/icons/favicon-512x512.png \
      $out/share/icons/hicolor/512x512/apps/splayer-next.png

    # Wrapper: symlink the bundled binary; wrapGAppsHook3 (via preFixup
    # gappsWrapperArgs below) turns it into a shell wrapper with the rpath,
    # xdg-utils on PATH and native Wayland when the session asks for it
    # (same pattern as helium.nix).
    ln -s $out/opt/splayer-next/SPlayer-Next $out/bin/splayer-next

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
    $out/bin/splayer-next --version
  '';

  meta = {
    homepage = "https://github.com/SPlayer-Dev/SPlayer-Next";
    description = "Cross-platform desktop music player with rich lyric support";
    license = lib.licenses.agpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.linux;
    mainProgram = "splayer-next";
    maintainers = [
      {
        name = "Ackerman-00";
        github = "Ackerman-00";
      }
    ];
  };
}
