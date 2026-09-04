{
  pkgs,
  lib,
  electron_42 ? null,
}:

let
  electron = electron_42;
  pname = "opencode-desktop";
  version = "1.18.28";

  archives = {
    x86_64-linux = pkgs.fetchurl {
      url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-desktop-linux-amd64.deb";
      hash = "sha256-C0O/FpJQZvxFrVAk+cHg5Ln2lBvZXOLCigs28D191EA=";
    };
    aarch64-linux = pkgs.fetchurl {
      url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-desktop-linux-arm64.deb";
      hash = "sha256-qXR9w5S6RSfCJLMviWHTj62QVq3e+pY+4bsBT9Nwfm4=";
    };
  };
in
pkgs.stdenv.mkDerivation rec {
  inherit pname version;

  src = archives.${pkgs.stdenv.hostPlatform.system};

  nativeBuildInputs = with pkgs; [
    dpkg
    makeBinaryWrapper
    copyDesktopItems
    autoPatchelfHook
  ];

  buildInputs = with pkgs; [
    stdenv.cc.cc.lib
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-x86_64.so.1"
    "libc.musl-x86_64.so"
    "libc.musl-aarch64.so.1"
    "libc.musl-aarch64.so"
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

    mkdir -p $out/bin $out/opt/opencode-desktop $out/share

    # Extract app resources for use with system Electron
    optDir=$(find opt -maxdepth 1 -mindepth 1 -type d)
    cp -r "$optDir/resources" $out/opt/opencode-desktop/
    cp -r usr/share/* $out/share/

    # Remove deb's desktop files
    rm -f $out/share/applications/*.desktop

    # Copy icons (from the deb or app resources)
    for size in 32 64 128; do
      if [ -f "$optDir/resources/icons/''${size}x''${size}.png" ]; then
        install -Dm644 "$optDir/resources/icons/''${size}x''${size}.png" \
          "$out/share/icons/hicolor/''${size}x''${size}/apps/opencode-desktop.png"
      fi
    done
    # Fallback: copy from share/icons if resources/icons not present
    if [ ! -f "$out/share/icons/hicolor/32x32/apps/opencode-desktop.png" ]; then
      for size in 32 64 128; do
        if [ -f "$out/share/icons/hicolor/''${size}x''${size}/apps/ai.opencode.desktop.png" ]; then
          install -Dm644 "$out/share/icons/hicolor/''${size}x''${size}/apps/ai.opencode.desktop.png" \
            "$out/share/icons/hicolor/''${size}x''${size}/apps/opencode-desktop.png"
          rm "$out/share/icons/hicolor/''${size}x''${size}/apps/ai.opencode.desktop.png"
        fi
      done
    fi

    # Use system Electron instead of the bundled one, following nixpkgs pattern
    makeBinaryWrapper ${lib.getExe electron} $out/bin/opencode-desktop \
      --inherit-argv0 \
      --set ELECTRON_FORCE_IS_PACKAGED 1 \
      --add-flags $out/opt/opencode-desktop/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    runHook postInstall
  '';

  meta = {
    homepage = "https://opencode.ai";
    description = "AI coding agent desktop client";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "opencode-desktop";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [
      {
        name = "Ackerman-00";
        github = "Ackerman-00";
      }
    ];
  };
}
