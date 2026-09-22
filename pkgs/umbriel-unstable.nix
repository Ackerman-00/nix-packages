# umbriel-unstable: latest upstream commit of umbriel
# (https://github.com/noctalia-dev/umbriel), tracked by update.yml
# (rust_rev_update: bumps rev + hash + version together; meson project, so
# the cargoHash steps no-op via the cargoHash guard).
#
# Vendored (not overrideAttrs): only the pin lines move per bump, insulating
# us from packaging churn elsewhere. Shape = nixpkgs' expression (Hydra-proven:
# strictDeps, __structuredAttrs, mesonInstallFlags --skip-subprojects, doCheck)
# UNION upstream's own nix/package.nix inputs (dbus, pipewire, systemd -
# ground truth at HEAD; extra libs are harmless, missing libs break builds).
# NO xwayland-satellite wrap by design (2026-09-22, upstream contract):
# umbriel docs require satellite "installed and on PATH" - it is an OPTIONAL
# external companion discovered at runtime, never a hardcoded build input.
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

  postInstall = ''
    if [ -f "$out/share/wayland-sessions/umbriel.desktop" ]; then
      substituteInPlace "$out/share/wayland-sessions/umbriel.desktop" \
        --replace-fail 'Exec=start-umbriel' "Exec=$out/bin/start-umbriel"
    fi
  '';

  doCheck = true;

  # Synthetic 0-unstable version can never match upstream tags; the flake's
  # own build+smoke in CI is the version check (same rationale as nixpkgs'
  # doInstallCheck = false for untagged umbriel).
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
