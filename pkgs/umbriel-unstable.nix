# umbriel-unstable: latest upstream commit, tracked by update.yml.
{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  wayland,
  wayland-protocols,
  wlroots_0_20,
  libxkbcommon,
  libinput,
  pixman,
  cairo,
  pango,
  libGL,
  libdrm,
  libgbm,
  libxcb,
  libxcb-wm,
  lcms2,
  jemalloc,
  tomlplusplus,
  nlohmann_json,
  dbus,
  pipewire,
  systemd,
}:

stdenv.mkDerivation {
  pname = "umbriel-unstable";
  # nixpkgs git-snapshot convention: sorts below any future real release,
  # so the upgrade path back to stable stays clean.
  version = "0-unstable-2026-09-22";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "umbriel";
    rev = "c6d7d57607845953a4eb431918e7792ed4b92d8e";
    hash = "sha256-EFSp61Uhu0rCviE8UeuqBt9ILhex+CUg0AxjmY+LSpQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    wayland-scanner
    wlroots_0_20
    libxkbcommon
    libinput
    pixman
    tomlplusplus
    libGL
    nlohmann_json
    libdrm
    libgbm
    libxcb
    libxcb-wm
    lcms2
    jemalloc
    cairo
    pango
    dbus
    pipewire
    systemd
  ];

  mesonBuildType = "release";

  mesonInstallFlags = [ "--skip-subprojects" ];

  postPatch = ''
    # Sandbox has no .git, so meson's vcs_tag falls back to 'unknown'.
    # Inject the pinned short rev instead (mirrors niri's NIRI_BUILD_COMMIT
    # practice): `umbriel --version` then prints base version + real commit.
    # Rewritten by update.yml on every bump.
    substituteInPlace meson.build \
      --replace-fail "fallback: 'unknown'" "fallback: 'c6d7d57'"
  '';

  postInstall = ''
    if [ -f "$out/share/wayland-sessions/umbriel.desktop" ]; then
      substituteInPlace "$out/share/wayland-sessions/umbriel.desktop" \
        --replace-fail 'Exec=start-umbriel' "Exec=$out/bin/start-umbriel"
    fi
  '';

  doCheck = true;

  doInstallCheck = false;

  passthru = {
    providedSessions = [ "umbriel" ];
  };

  meta = {
    description = "Wayland compositor built on wlroots and umbrielfx (latest upstream commit)";
    homepage = "https://docs.noctalia.dev/umbriel/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "umbriel";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = [
      {
        name = "Ackerman-00";
        github = "Ackerman-00";
      }
    ];
  };
}
