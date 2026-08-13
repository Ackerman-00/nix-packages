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

    # The AppImage entry point is AppRun.sh, which sources every bin/*.hook
    # and then execs the sharun runtime. The 01-* hooks are load-bearing:
    # 01-check-ca-certs.hook points the bundled p11-kit-trust.so (patched to
    # hardcode /etc/ca-certificates/trust-source:/tmp/.___host-certs/
    # ca-certificates.crt) at the host CA store, and
    # 01-path-mapping-hardcoded.hook maps /tmp/pKE -> $APPDIR/lib and
    # /tmp/3J=1Z -> $APPDIR/share, paths the patched app binary hardcodes.
    # Without them all HTTPS downloads fail. Replace AppRun.sh with a
    # bin/protonplus wrapper that sources the 01-* hooks (self-updater.hook
    # is skipped: the store is read-only) and execs the renamed sharun
    # runtime, which resolves the app via its own filename from shared/bin.
    mv $out/bin/protonplus $out/bin/protonplus-runtime
    ln -s protonplus $out/shared/bin/protonplus-runtime
    cat > $out/bin/protonplus <<'EOF'
#!/${pkgs.stdenv.shell}
APPDIR="$(dirname "$(dirname "$(readlink -f "$0")")")"
export APPDIR
export PATH="$APPDIR/bin:$PATH"
for hook in "$APPDIR"/bin/01-*.hook; do
    [ -e "$hook" ] || continue
    . "$hook"
done
exec "$APPDIR/bin/protonplus-runtime" "$@"
EOF
    chmod +x $out/bin/protonplus
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
