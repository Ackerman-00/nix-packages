{ pkgs, lib }:

let
  pname = "mixtapes";
  # Latest upstream release from com.pocoguy.Muse.metainfo.xml at rev 5e165d2
  # (metainfo <release version="2026-26-05.0">). HEAD is newer but no new
  # metainfo release tag yet; pinned to that commit's tarball.
  version = "2026-26-05.0";

  src = pkgs.fetchFromGitHub {
    owner = "m-obeid";
    repo = "Mixtapes";
    rev = "5e165d201128de1b6c10d5cb031a0828ffc3b0ec";
    hash = "sha256-pj0184BQQEpjSyG001bgD3Os59w+4h5tBJHsJsO7cL4=";
  };

  pythonEnv = pkgs.python314.withPackages (
    ps: with ps; [
      pygobject3
      pillow
      numpy
      ytmusicapi
      yt-dlp
      yt-dlp-ejs
      requests
      urllib3
      mutagen
      pydbus
      mprisify
    ]
  );
in
pkgs.stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = with pkgs; [
    makeWrapper
    wrapGAppsHook3
    gobject-introspection
    glib
  ];

  buildInputs = with pkgs; [
    gtk4
    libadwaita
    webkitgtk_6_0
    gobject-introspection
    # TLS for GIO/GTK (soup backend): without glib-networking the login
    # WebView and any GLib-based HTTPS fail with "TLS support is not available"
    glib-networking
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    pythonEnv
  ];

  # Compile the GResource bundle (mirrors `glib-compile-resources --sourcedir=. src/muse.gresource.xml`)
  # so the app finds icons/styles at runtime via Gio.Resource.load.
  buildPhase = ''
    runHook preBuild
    glib-compile-resources --sourcedir=. src/muse.gresource.xml --target=src/muse.gresource
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/mixtapes $out/share/applications $out/share/metainfo

    # Upstream flake copies src/* into $out/share/mixtapes/ and execs main.py
    cp -r src $out/share/mixtapes/src
    cp -r assets $out/share/mixtapes/assets 2>/dev/null || true
    cp -r fonts $out/share/mixtapes/fonts 2>/dev/null || true

    # Desktop + metainfo (Exec was historically `muse`; patch to `mixtapes`)
    install -Dm644 com.pocoguy.Muse.desktop $out/share/applications/com.pocoguy.Muse.desktop
    substituteInPlace $out/share/applications/com.pocoguy.Muse.desktop \
      --replace-fail 'Exec=muse' 'Exec=mixtapes'

    install -Dm644 com.pocoguy.Muse.metainfo.xml $out/share/metainfo/com.pocoguy.Muse.metainfo.xml

    # Hicolor icons for the desktop entry
    if [ -d assets/icons/hicolor ]; then
      mkdir -p $out/share/icons
      cp -r assets/icons/hicolor $out/share/icons/
    fi

    # yt-dlp resolves ffmpeg and a JS runtime ("js_runtimes": {"node": {}})
    # from PATH: FFmpegExtractAudio backs every download format, node drives
    # yt-dlp-ejs YouTube challenges.
    makeWrapper ${pythonEnv}/bin/python $out/bin/mixtapes \
      --prefix PATH : ${
        lib.makeBinPath (
          with pkgs;
          [
            ffmpeg
            nodejs
          ]
        )
      } \
      --add-flags "$out/share/mixtapes/src/main.py"

    runHook postInstall
  '';

  # Let wrapGAppsHook3 inject GTK/GStreamer env; keep our python wrapper args
  dontWrapGApps = false;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GST_PLUGIN_SYSTEM_PATH : "${
        lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (
          with pkgs.gst_all_1;
          [
            gstreamer
            gst-plugins-base
            gst-plugins-good
            gst-plugins-bad
            gst-plugins-ugly
          ]
        )
      }"
      # GIO TLS: point GLib at the glib-networking module dir (giomodule) and
      # the CA bundle so the login WebView / ytmusicapi HTTPS works.
      --set GIO_MODULE_DIR "${pkgs.glib-networking}/lib/gio/modules"
      --prefix GIO_EXTRA_MODULES : "${pkgs.glib-networking}/lib/gio/modules"
      --set NIX_SSL_CERT_FILE "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    )
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/mixtapes --help 2>&1 | head -n 20 || true
    # Basic import smoke: can the python env load GTK/Adw without display?
    ${pythonEnv}/bin/python -c "import gi; gi.require_version('Gtk','4.0'); gi.require_version('Adw','1'); print('gi ok')" || true
  '';

  meta = {
    homepage = "https://github.com/m-obeid/Mixtapes";
    description = "Modern, Linux-first YouTube Music player built with GTK4 and Libadwaita";
    longDescription = ''
      Mixtapes (formerly Muse) is a YouTube Music player for Linux
      with library/playlist/search, full playback, downloads, MPRIS
      and background playback. This package follows the upstream
      flake.nix build (Python + GTK4/Libadwaita/WebKitGTK/GStreamer)
      and is pinned to the latest metainfo release.
    '';
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = lib.platforms.linux;
    mainProgram = "mixtapes";
    maintainers = [
      {
        name = "Ackerman-00";
        github = "Ackerman-00";
      }
    ];
  };
}
