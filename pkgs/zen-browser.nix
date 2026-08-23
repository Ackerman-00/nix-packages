{ pkgs, lib }:

let
  pname = "zen-browser";
  version = "1.21.15b";

  archives = {
    x86_64-linux = pkgs.fetchurl {
      url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-x86_64.tar.xz";
      hash = "sha256-Lq6mZLhABnygrOYjvU9FSPrpj0apji3b39y5JTtnS78=";
    };
    aarch64-linux = pkgs.fetchurl {
      url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-aarch64.tar.xz";
      hash = "sha256-c6YJuVTn3O+NxJse/JwTtojs+iS6Gz85rWU+kyS4ic8=";
    };
  };

  src = archives.${pkgs.stdenv.hostPlatform.system};
in
pkgs.stdenv.mkDerivation {
  inherit pname version src;

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    pkgs.autoPatchelfHook
    pkgs.wrapGAppsHook3
    pkgs.patchelfUnstable
    pkgs.copyDesktopItems
  ];

  buildInputs = [
    pkgs.gtk3
    pkgs.adwaita-icon-theme
    pkgs.alsa-lib
    pkgs.dbus-glib
    pkgs.libXtst
    pkgs.ffmpeg_8
  ];

  runtimeDependencies = [
    pkgs.curl
    pkgs.libva.out
    pkgs.pciutils
    pkgs.libGL
  ];

  appendRunpaths = [
    "${pkgs.libGL}/lib"
    "${pkgs.pipewire}/lib"
  ];

  # Firefox uses "relrhack" to manually process relocations from a fixed
  # offset, so a patchelf new enough to preserve old sections is required;
  # autoPatchelfHook picks up the patchelfUnstable binary from PATH.
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ pkgs.ffmpeg_8 ]}"
      --add-flags "--name=''${MOZ_APP_LAUNCHER:-zen-browser}"
      --add-flags "--class=''${MOZ_APP_LAUNCHER:-zen-browser}"
    )
  '';

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "zen-browser";
      desktopName = "Zen Browser";
      exec = "zen-browser %u";
      icon = "zen-browser";
      type = "Application";
      mimeTypes = [
        "text/html"
        "text/xml"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "application/x-xpinstall"
        "application/pdf"
        "application/json"
      ];
      startupWMClass = "zen-browser";
      categories = [
        "Network"
        "WebBrowser"
      ];
      startupNotify = true;
      terminal = false;
      extraConfig.X-MultipleArgs = "false";
      keywords = [
        "Internet"
        "WWW"
        "Browser"
        "Web"
        "Explorer"
      ];
      actions = {
        new-window = {
          name = "Open a New Window";
          exec = "zen-browser %u";
        };
        new-private-window = {
          name = "Open a New Private Window";
          exec = "zen-browser --private-window %u";
        };
        profile-manager = {
          name = "Open the Profile Manager";
          exec = "zen-browser --ProfileManager %u";
        };
      };
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/zen-bin-${version}
    cp -r . $out/lib/zen-bin-${version}/
    mkdir -p $out/bin
    ln -s $out/lib/zen-bin-${version}/zen $out/bin/zen-browser
    install -D $out/lib/zen-bin-${version}/browser/chrome/icons/default/default16.png \
      $out/share/icons/hicolor/16x16/apps/zen-browser.png
    install -D $out/lib/zen-bin-${version}/browser/chrome/icons/default/default32.png \
      $out/share/icons/hicolor/32x32/apps/zen-browser.png
    install -D $out/lib/zen-bin-${version}/browser/chrome/icons/default/default48.png \
      $out/share/icons/hicolor/48x48/apps/zen-browser.png
    install -D $out/lib/zen-bin-${version}/browser/chrome/icons/default/default64.png \
      $out/share/icons/hicolor/64x64/apps/zen-browser.png
    install -D $out/lib/zen-bin-${version}/browser/chrome/icons/default/default128.png \
      $out/share/icons/hicolor/128x128/apps/zen-browser.png
    runHook postInstall
  '';

  meta = {
    homepage = "https://zen-browser.app";
    description = "Beautifully designed privacy-focused Firefox fork with vertical tabs and workspaces";
    downloadPage = "https://zen-browser.app/download/";
    changelog = "https://github.com/zen-browser/desktop/releases";
    license = lib.licenses.mpl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "zen-browser";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [
      {
        name = "Ackerman-00";
        github = "Ackerman-00";
      }
    ];
  };
}
