# xwayland-satellite-unstable: latest upstream commit, tracked by update.yml.
{
  lib,
  fetchFromGitHub,
  installShellFiles,
  libxcb,
  libxcb-cursor,
  makeBinaryWrapper,
  pkg-config,
  rustPlatform,
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
