{ pkgs, lib }:

pkgs.stdenv.mkDerivation rec {
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
    copyDesktopItems
  ];

  buildInputs = with pkgs; [
    alsa-lib at-spi2-atk at-spi2-core atk cairo cups dbus expat fontconfig
    freetype gdk-pixbuf glib gtk3 libdrm libglvnd libnotify libxkbcommon
    mesa nspr nss pango systemd
    libx11 libxscrnsaver libxcomposite libxcursor
    libxdamage libxext libxfixes libxi libxrandr libxrender
    libxtst libxcb libxkbfile libxshmfence
    stdenv.cc.cc.lib
    gsettings-desktop-schemas
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-x86_64.so.1"
  ];

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "opencode-desktop";
      desktopName = "OpenCode";
      exec = "opencode-desktop %U";
      icon = "opencode-desktop";
      startupWMClass = "ai.opencode.desktop";
      categories = [ "Development" ];
      mimeTypes = [ "x-scheme-handler/opencode" ];
    })
  ];

  unpackPhase = ''
    dpkg -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -R opt/ $out/
    cp -R usr/share/* $out/share/

    # Remove the deb's desktop files — use makeDesktopItem instead
    rm -f $out/share/applications/*.desktop

    find $out/opt -type d -name "*musl*" -exec rm -rf {} + 2>/dev/null || true

    APP_DIR=$(find $out/opt -maxdepth 1 -mindepth 1 -type d)

    APP_BINARY=$(find "$APP_DIR" -maxdepth 1 -type f -name 'ai.opencode.desktop')
    if [ -z "$APP_BINARY" ]; then
      APP_BINARY=$(find "$APP_DIR" -maxdepth 1 -type f -executable ! -name '*.so' ! -name 'chrome-sandbox' ! -name 'chrome_crashpad_handler' | head -1)
    fi

    wrapProgram "$APP_BINARY" \
      --add-flags "--no-sandbox" \
      --add-flags "--use-angle=swiftshader" \
      --add-flags "''${NIXOS_OZONE_WL:+''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,UseOzonePlatform}}" \
      --prefix LD_LIBRARY_PATH : "${pkgs.libglvnd}/lib" \
      --set GSETTINGS_SCHEMAS_DIR "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas"

    ln -s "$APP_BINARY" $out/bin/opencode-desktop

    # Rename icons to match desktop item name
    for size in 32 64 128; do
      if [ -f "$out/share/icons/hicolor/''${size}x''${size}/apps/ai.opencode.desktop.png" ]; then
        install -Dm644 "$out/share/icons/hicolor/''${size}x''${size}/apps/ai.opencode.desktop.png" \
          "$out/share/icons/hicolor/''${size}x''${size}/apps/opencode-desktop.png"
        rm "$out/share/icons/hicolor/''${size}x''${size}/apps/ai.opencode.desktop.png"
      fi
    done

    runHook postInstall
  '';
}
