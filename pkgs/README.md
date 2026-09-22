# pkgs/ — package conventions

Inventory is derived every run via `ls pkgs/*.nix` — never hardcode a list.

## meta (every package)

- `description`: one sentence, capitalized, no trailing period, factual
- `license`: correct SPDX id (`lib.licenses.*`); proprietary needs
  `allowUnfree = true` in `flake.nix` (rootapp)
- `sourceProvenance`:
  - binary-native (fetchurl tarball/AppImage): `with lib.sourceTypes; [ binaryNativeCode ]`
  - source builds: `with lib.sourceTypes; [ fromSource ]`
- `mainProgram`: exact installed bin name
- `platforms`: `lib.platforms.linux` (or the explicit arch list for
  dual-arch tarballs)
- `maintainers`: Ackerman-00

## Versioning

- Upstream releases: plain upstream version (`1.22.2b`, `1.1.0`, `0.9.132`) —
  must start with a digit.
- Rev-pinned git snapshots: `0-unstable-YYYY-MM-DD` (nixpkgs git-snapshot
  convention; sorts below any future real release so the upgrade path back to
  stable stays clean). `update.yml` rewrites `rev`/`hash`/`version` on every
  bump; `git ls-remote HEAD` must equal the pinned `rev` at audit time.
- mixtapes' metainfo `-git` scheme:
  `base (metainfo release at this rev)^gitdate git shortrev` — derived, not
  hand-picked.

## Hashes

- SRI only: `sha256-...` (never hex). Compute with
  `nix hash to-sri --type sha256 $(nix-prefetch-url --type sha256 <url>)`
  or `nix hash to-sri --type sha256 $(nix hash convert --hash-algo sha256 --to sri <hex>)`.
- `fetchFromGitHub` preferred over raw `fetchurl` for GitHub sources.

## Dep audit contract

Every run tears each expression apart (extract archive → `readelf -d`/`ldd`
NEEDED ∪ `runtimeDeps`/`buildInputs`), diffs upstream reference files (flakes,
`Cargo.toml`, `meson.build`, `nix/package.nix`, nixpkgs official by-name when
it exists), and records the verdict in `.opencode-relay.md`. Every
`NEEDED .so` must resolve via `runtimeDeps` + `makeLibraryPath`, an explicit
`buildInputs` entry, or be bundled in the archive — proven by a fresh
`nixos/nix` container build (`auto-patchelf: 0 dependencies could not be
satisfied`) plus `nix run` smoke.

## No-hardcode rule

`xwayland-satellite` is never wrapped into a compositor (niri/umbriel) —
both upstreams discover it on `$PATH` at runtime as optional companion
software; pair them via `environment.systemPackages` (README). X11 support =
install `xwayland-satellite-unstable` alongside the compositor.
