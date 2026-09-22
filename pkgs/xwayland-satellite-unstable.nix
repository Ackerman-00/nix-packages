# xwayland-satellite-unstable: latest upstream commit of xwayland-satellite
# (https://github.com/Supreeeme/xwayland-satellite), tracked by update.yml
# (rust_rev_update: bumps rev + hash + cargoHash + version together).
#
# Vendored (not overrideAttrs): rustPlatform.buildRustPackage consumes src +
# cargoHash at call time to build its vendor derivation, so post-hoc overrides
# silently keep the OLD vendor hash. A full expression also insulates us from
# upstream-packaging churn: only these 4 lines move per bump.
# Shape verified 2026-09-22 against BOTH nixpkgs (Hydra-proven) and upstream's
# README (Xwayland>=23.1, xcb, xcb-util-cursor; systemd+fontconfig optional,
# defaults off). niri-unstable wraps THIS package onto its PATH.
{
  lib,
  fetchFromGitHub,
  installShellFiles,
  libxcb,
  libxcb-cursor,
  makeBinaryWrapper,
  pkg-config,
  rustPlatform,
  stdenv,
  xwayland,
  withSystemd ? true,
}:

rustPlatform.buildRustPackage {
  pname = "xwayland-satellite-unstable";
  version = "0-unstable-2026-09-21";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    rev = "add2795134593faafce60e404a0a75df68e9ee0c";
    hash = "sha256-0TxfMgqW0/BLD4M942c5DCKYrtPvzsPJwvdcco4LQUM=";
  };

  cargoHash = "sha256-s1gl9eR6Mt2QLrhfcowstPFjzwE/lz4PJhJzWYHoIHg=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libxcb
    libxcb-cursor
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional withSystemd "systemd";

  outputs = [
    "out"
    "man"
  ];

  postPatch = ''
    substituteInPlace resources/xwayland-satellite.service \
      --replace-fail '/usr/local/bin/xwayland-satellite' "$out/bin/xwayland-satellite"
  '';

  # All integration tests require a running display server
  doCheck = false;

  postInstall = ''
    installManPage --name xwayland-satellite.1 xwayland-satellite.man
  ''
  + lib.optionalString withSystemd ''
    install -Dm0644 resources/xwayland-satellite.service -t $out/lib/systemd/user
  '';

  postFixup = ''
    wrapProgram $out/bin/xwayland-satellite \
      --prefix PATH : "${lib.makeBinPath [ xwayland ]}"
  '';

  meta = {
    description = "Xwayland outside your Wayland compositor (latest upstream commit)";
    longDescription = ''
      Grants rootless Xwayland integration to any Wayland compositor implementing xdg_wm_base.
    '';
    homepage = "https://github.com/Supreeeme/xwayland-satellite";
    changelog = "https://github.com/Supreeeme/xwayland-satellite/commits/main";
    license = lib.licenses.mpl20;
    mainProgram = "xwayland-satellite";
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = [
      {
        name = "Ackerman-00";
        github = "Ackerman-00";
      }
    ];
  };
}
