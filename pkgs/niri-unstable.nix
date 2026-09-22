# niri-unstable: latest upstream commit, tracked by update.yml.
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
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "niri-unstable";
  # nixpkgs git-snapshot convention: sorts below any future real release,
  # so the upgrade path back to stable stays clean.
  version = "0-unstable-2026-09-22";

  src = fetchFromGitHub {
    owner = "niri-wm";
    repo = "niri";
    rev = "5f4469b6a992492cf7221b269e9379f42e737649";
    hash = "sha256-3nX7BEcI3swElm9J5GycBkyglLYWumtKcIz9eMuo+Ug=";
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

  cargoHash = "sha256-vtTh+TG6TdX46QydGKaeo50u2qdQf3UkQ50EML+5H9c=";

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
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

  # No satellite wrap: upstream resolves it on PATH at runtime (optional companion).
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
    NIRI_BUILD_COMMIT = "5f4469b";
  };

  checkFlags = [ "--skip=::egl" ];

  # versionCheckHook would compare `niri --version` against our synthetic
  # 0-unstable version and fail - the flake's own build+smoke is the check.
  doInstallCheck = false;

  passthru = {
    # REQUIRED by services.displayManager.sessionPackages ("package with
    # provided sessions" type): without this, NixOS rejects the package as a
    # login session (seen live 2026-09-22). Matches nixpkgs' own niri.
    providedSessions = [ "niri" ];
  };

  meta = {
    description = "Scrollable-tiling Wayland compositor (latest upstream commit)";
    homepage = "https://github.com/niri-wm/niri";
    changelog = "https://github.com/niri-wm/niri/commits/main";
    license = lib.licenses.gpl3Only;
    mainProgram = "niri";
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = [
      {
        name = "Ackerman-00";
        github = "Ackerman-00";
      }
    ];
  };
})
