# xdg-desktop-portal-umbriel-unstable: latest upstream commit of umbriel's
# portal backend (https://github.com/noctalia-dev/xdg-desktop-portal-umbriel),
# tracked by update.yml. Without it umbriel cannot screenshare - pair with
# umbriel-unstable (see README). Shape = nixpkgs' expression verbatim
# (identical dep lists upstream vs nixpkgs, meson, no cargoHash).
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
  sdbus-cpp_2,
  systemd,
  pipewire,
  libdrm,
  libgbm,
  cairo,
  tomlplusplus,
  nlohmann_json,
  gtk4,
}:

let
  rev = "d7a1bc386c2a6dfaecaa953165f9f373735c9ee0";
in
stdenv.mkDerivation {
  pname = "xdg-desktop-portal-umbriel-unstable";
  version = "0-unstable-2026-09-07";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "xdg-desktop-portal-umbriel";
    inherit rev;
    hash = "sha256-x2D1TiCn0rTwbA8darNxthxOWOCoZLwefptsUM7587I=";
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
    sdbus-cpp_2
    systemd
    pipewire
    libdrm
    libgbm
    cairo
    tomlplusplus
    nlohmann_json
    gtk4
  ];

  mesonBuildType = "release";

  # Upstream meson installs the daemon to libexecdir only (nixpkgs' expression
  # inherits that), so `nix run .#pkg` had no bin/ entry to execute. Expose it
  # so the advertised `nix run` path in README works.
  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/libexec/xdg-desktop-portal-umbriel $out/bin/xdg-desktop-portal-umbriel
  '';

  meta = {
    homepage = "https://github.com/noctalia-dev/xdg-desktop-portal-umbriel";
    description = "xdg-desktop-portal backend for the Umbriel compositor (latest upstream commit)";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "xdg-desktop-portal-umbriel";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = [
      {
        name = "Ackerman-00";
        github = "Ackerman-00";
      }
    ];
  };
}
