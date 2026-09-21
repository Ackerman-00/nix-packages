# niri-unstable: latest upstream commit of niri (https://github.com/niri-wm/niri),
# tracked by update.yml (rust_rev_update: bumps rev + hash + cargoHash +
# version + NIRI_BUILD_COMMIT together).
#
# Vendored (not overrideAttrs): rustPlatform.buildRustPackage consumes src +
# cargoHash at call time to build its vendor derivation, so post-hoc overrides
# silently keep the OLD vendor hash. A full expression also insulates us from
# packaging churn elsewhere: only the pin lines move per bump.
# Shape verified 2026-09-22 against BOTH nixpkgs' expression (Hydra-proven:
# libglvnd/wayland/eudev split, versionCheckHook) and upstream's own flake.nix
# (community-maintained in-repo: cairo + libGL, NIRI_BUILD_COMMIT = revision,
# XDG_RUNTIME_DIR preCheck). Where they disagree the build decides: this file
# follows the nixpkgs shape (proven to compile) + upstream's NIRI_BUILD_COMMIT
# practice (their wiki: set the commit hash when no git checkout is available).
# xwayland-satellite-unstable is wrapped onto PATH: niri execs it at runtime.
{
  lib,
  dbus,
  eudev,
  fetchFromGitHub,
  installShellFiles,
  libdisplay-info_0_3,
  libglvnd,
  libinput,
  libxkbcommon,
  libgbm,
  makeBinaryWrapper,
  pango,
  pipewire,
  pkg-config,
  rustPlatform,
  seatd,
  stdenv,
  systemd,
  versionCheckHook,
  wayland,
  withDbus ? true,
  withScreencastSupport ? true,
  withSystemd ? true,
  xwayland-satellite-unstable,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "niri-unstable";
  # nixpkgs git-snapshot convention: sorts below any future real release,
  # so the upgrade path back to stable stays clean.
  version = "0-unstable-2026-09-21";

  src = fetchFromGitHub {
    owner = "niri-wm";
    repo = "niri";
    rev = "8be4c6df68ddef2afd4ccdde7f27dbc782c30603";
    hash = "sha256-z2NJYe1zfVoFQKbkowMtBEr+m8al8oT3JVimA9N9Xow=";
  };

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
    patchShebangs resources/niri-session
    substituteInPlace resources/niri.service \
      --replace-fail 'niri' "$out/bin/niri"
  '';

  cargoHash = "sha256-Yqvambc4F7PdGkGxrxp5xD6PqAEAWmMgqOYZRY+TIBA=";

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libdisplay-info_0_3
    libglvnd # For libEGL
    libinput
    libxkbcommon
    libgbm
    pango
    seatd
    wayland # For libwayland-client
  ]
  ++ lib.optional (withDbus || withScreencastSupport || withSystemd) dbus
  ++ lib.optional withScreencastSupport pipewire
  ++ lib.optional withSystemd systemd # Includes libudev
  ++ lib.optional (!withSystemd) eudev;

  buildFeatures =
    lib.optional withDbus "dbus"
    ++ lib.optional withScreencastSupport "xdp-gnome-screencast"
    ++ lib.optional withSystemd "systemd";
  buildNoDefaultFeatures = true;

  postInstall = ''
    install -Dm0644 README.md resources/default-config.kdl -t $doc/share/doc/niri
    mv docs/wiki $doc/share/doc/niri/wiki

    install -Dm0644 resources/niri.desktop -t $out/share/wayland-sessions
  ''
  + lib.optionalString withDbus ''
    install -Dm0644 resources/niri-portals.conf -t $out/share/xdg-desktop-portal
  ''
  + lib.optionalString withSystemd ''
    install -Dm0755 resources/niri-session -t $out/bin
    install -Dm0644 resources/niri{-shutdown.target,.service} -t $out/lib/systemd/user
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd niri \
      --bash <($out/bin/niri completions bash) \
      --fish <($out/bin/niri completions fish) \
      --nushell <($out/bin/niri completions nushell) \
      --zsh <($out/bin/niri completions zsh)
  '';

  postFixup = ''
    wrapProgram $out/bin/niri \
      --prefix PATH : "${lib.makeBinPath [ xwayland-satellite-unstable ]}"
  '';

  env = {
    # Force linking with libEGL and libwayland-client
    # so they can be discovered by `dlopen()`
    RUSTFLAGS = toString (
      map (arg: "-C link-arg=" + arg) [
        "-Wl,--push-state,--no-as-needed"
        "-lEGL"
        "-lwayland-client"
        "-Wl,--pop-state"
      ]
    );

    # Upstream wiki (Packaging-niri): set the commit hash manually when no
    # git checkout is available. Rewritten by update.yml on every bump.
    NIRI_BUILD_COMMIT = "8be4c6d";
  };

  checkFlags = [ "--skip=::egl" ];

  # versionCheckHook would compare `niri --version` against our synthetic
  # 0-unstable version and fail - the flake's own build+smoke is the check.
  doInstallCheck = false;

  meta = {
    description = "Scrollable-tiling Wayland compositor (latest upstream commit)";
    homepage = "https://github.com/niri-wm/niri";
    changelog = "https://github.com/niri-wm/niri/commits/main";
    license = lib.licenses.gpl3Only;
    mainProgram = "niri";
    platforms = lib.platforms.linux;
  };
})
