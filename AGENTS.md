# AGENTS.md — nix-packages

Work-notes for AI agents and humans maintaining this repo.

## Self-healing sweep architecture (added 2026-08-21)

Three-layer defense-in-depth for package staleness and integrity:

### Layer 1: Deterministic Python sweep (`tools/teardown-sweep.py`) — AUXILIARY, NOT VERDICT

Pure stdlib helper the **agent calls** (not a separate CI gate). Downloads every
artifact, tears it apart (AppImage extract, .deb control, zip internals, Electron
.asar, `application.ini`, ELF `--version` probe), verifies checksums (sha256-SRI,
BLAKE2B+SHA512), reads internal versions vs upstream, and (2026-08) runs
`nix flake check`/`nixpkgs-hammering`/`nixfmt` hooks for Nix. The agent IS the teardown — it must tear every `pkgs/*.nix` + `flake.nix` apart itself, run `nix flake check` + `nix build` + `nix run` in Docker, produce the
dependency audit table, and ensure excellent flake/nixpkgs packaging. Sweep is evidence,
not a pass-anyway script; CI gate hard-fails if the agent skips it.

Key functions:
- `resolve_canonical_repo()`: detects GitHub forks via API `parent.full_name`,
  compares against canonical upstream (not the fork)
- `is_chromium_build_number()`: filters Chromium engine build numbers
  (first component >= 50) from version probes
- `is_template_version()`: auto-detects RPM macros (%{bumpver}, %{shortcommit0}),
  bash expansions, git snapshots — skips them automatically (no hardcoded lists)
- `versions_match()`: handles both prefix and suffix version alignment
  (e.g. Chromium `143.1.93.137` vs Brave `1.93.137`)
- `staleness_pv()`: strips +build, .git-hash, -r1, ^git, ~beta suffixes
- `repology_newest()`: queries Repology API (120+ repos) for ANY package
- `repology_dep_info()`: gets upstream version + status from Repology
- `osv_query()`: queries OSV.dev for known CVEs on ANY package
- `compute_libyear()`: computes libyear drift from GitHub release dates
- `fix_stale_pkg()`: mechanical auto-fix — sed version in ebuild/spec/nix/template
- `--autofix` flag: when STALE is detected, auto-fix and re-verify

Exit code = verdict. Exit 0 = all packages verified. Exit 1 = any
FAIL/MISMATCH/STALE/UNVERIFIED → CI opens an issue.

### Layer 1b: Docker battle test + dependency sweep (`tools/docker-sweep.py`) — MANDATORY

Runs INSIDE the agent, clean `nixos/nix:latest` every run:
1. `nix --extra-experimental-features "nix-command flakes" build .#packages.x86_64-linux.<pkg>` for EVERY package (x86_64 + aarch64)
2. `nix run .#<pkg> -- --version` smoke + `ldd` via `result/bin`
3. Battle-tests `ls -R` (all `pkgs/*.nix`, `flake.nix`/`flake.lock`, `.github/workflows/*.yml`, `README.md` `nix run` path)
4. Reports `| package | nix build | nix run | status |` — any fail = fix nix/README

Key features:
- `trivy_scan_image()`: scans base images for CRITICAL/HIGH/MEDIUM CVEs
- `--scan-images` flag: enables Trivy CVE scanning
- No manual `tar` fallback — docker battle test is mandatory

### Layer 2: Agentic self-healing prompt (opencode-schedule.yml PROMPT) — MANDATORY

YOU are the sweep. The PROMPT's TEAR-APART + DOCKER BATTLE TEST is NOT optional.
It must:

1. Tear every `pkgs/*.nix` + `flake.nix`/`flake.lock` apart itself (fetchurl → extract → `ldd` NEEDED vs `runtimeDeps`/`makeLibraryPath`), run 2026 toolchain: `nix flake check` + `nixfmt` + `nixpkgs-hammering` (pkgs/README.md Aug 2026), `nix build` + `nix run` — log output
2. Produce mandatory `| package | upstream deps | in nix | missing | status |` for ALL 5 packages
   - OSV.dev vulnerability scan (CVEs on pinned version)
   - Repology freshness (outdated vs 120+ repos)
   - Libyear drift (years behind upstream, budget=20yr)
   - Auto-update tool hints (livecheck, autocopr, nix-update)
3. For each OUTDATED: use the suggested auto-update tool to fix it
4. For each FAIL/MISMATCH: re-download, verify checksum, update if re-released
5. LIBYEAR ENFORCEMENT: if >20 yr, prioritize highest-drift packages
6. Never close a teardown issue without passing sweep + evidence
7. False positive defense: fix the sweep script, never weaken checks

### Layer 3: CI gate + issue auto-open — ENFORCED

`gate_passes()` now hard-checks that `.opencode-relay.md` contains `run_id` + `status: complete` + `PACKAGE.*BR.*Req` / `deps-verified` / `dependency audit`.
If the agent skips the table, the job fails and retries with stronger model.

### Why this architecture

- **Deterministic + intelligent**: the sweep is pure Python (no LLM needed,
  no hallucination, fast). The agent handles complex cases that require
  reasoning about upstream changes.
- **Universal**: works for ANY package — Repology, OSV.dev, GitHub API,
  Trivy. No hardcoded skip lists or package-specific logic.
- **Self-healing**: genuinely stale packages get auto-fixed by the sweep's
  `--autofix` and/or the agent's investigation. False positives get caught
  and the sweep is improved.
- **Proof-or-Stop**: exit code = verdict. No claims without evidence.
  The sweep output is committed to the repo as a receipt.
- **Defense-in-depth**: even if one layer misses, the next catches it.
  Fork detection, template version detection, libyear budget, and
  Trivy CVE scanning prevent the known false positive classes.
