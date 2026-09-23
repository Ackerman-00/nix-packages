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
  rev = "80a74319bb9fef2ab604382026fc61646a8397ef";
in
stdenv.mkDerivation {
  pname = "xdg-desktop-portal-umbriel-unstable";
  version = "0-unstable-2026-09-23";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "xdg-desktop-portal-umbriel";
    inherit rev;
    hash = "sha256-0pskKu2flqUu7GGJ9gocN1PvMaZKRu7y+nIHBLmtxjI=";
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
