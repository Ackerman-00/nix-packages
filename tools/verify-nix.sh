#!/usr/bin/env bash
set -euo pipefail
# 2026 battle-tested verifier -- nix-packages. Returns 0 only if agent truly finished.
RUN_ID="${RUN_ID:-}"
RELAY=".opencode-relay.md"
FAIL=0
echo "----- VERIFICATION REPORT -----"
if [[ -f "$RELAY" ]]; then
  npkgs=$(find pkgs -maxdepth 1 -name '*.nix' | wc -l)
  dep_rows=$(grep -c "deps-verified\|deps-fixed\|version-checked" "$RELAY" 2>/dev/null || true)
  dep_rows=${dep_rows:-0}
  echo "Inventory: $npkgs nix packages; dependency table rows: $dep_rows"
  echo "(statuses: deps-verified = container teardown this run; version-checked = updater/tags/API only)"
  if [[ "$dep_rows" -lt "$npkgs" ]]; then
    echo "FAIL: dependency audit table has $dep_rows rows, need $npkgs (one per pkgs/*.nix)"
    FAIL=1
  else
    echo "PASS: Dependency table: $dep_rows rows (>= $npkgs)"
  fi
  for tool in "nix flake check" "nix build" "nixfmt"; do
    if ! grep -qi "$tool.*PASS\|PASS.*$tool" "$RELAY"; then
    echo "FAIL: NOT COMPLETE -- relay missing fresh evidence for $tool (with PASS result)"
    FAIL=1
  fi
  done
  if ! grep -qi "install-test table\|nix build.*nix run" "$RELAY"; then
    echo "FAIL: install-test table missing in relay"
    FAIL=1
  else
    echo "PASS: Install-test table present"
  fi
  if ! grep -qi "DOCKER BATTLE TEST\|nixos/nix.*build" "$RELAY"; then
    echo "FAIL: NOT COMPLETE -- relay missing Docker battle test evidence"
    FAIL=1
  fi
  # TEARDOWN TOKENS (2026-09-22): every inventory package must carry a fresh
  # `nix-teardown: <pkg> img:sha256:<digest> build PASS run PASS` token. The
  # digest proves a real nixos/nix container was pulled/used (host-nix builds
  # do NOT count). Rows are cheap, container builds are proof.
  TODAY=$(date -u +%F); YEST=$(date -u -d yesterday +%F 2>/dev/null || date -u -v-1d +%F)
  missing_teardown=0
  while IFS= read -r spec; do
    pkg=$(basename "$spec" .nix)
    if ! grep -qiE "nix-teardown: $pkg img:sha256:[0-9a-f]{12,} .*PASS" "$RELAY"; then
      echo "FAIL: NOT COMPLETE -- package '$pkg' has no nix-teardown PASS token with nixos/nix image digest (fresh-container nix build + nix run smoke)"
      missing_teardown=$((missing_teardown+1))
    fi
  done < <(find pkgs -maxdepth 1 -name '*.nix')
  if [[ "$missing_teardown" -gt 0 ]]; then
    FAIL=1
  else
    echo "PASS: all $npkgs packages carry nix-teardown PASS with image digest"
  fi
  # TOKEN PROVENANCE (2026-09-22): the gh-rate line proves GitHub API went
  # through the token (not the 60/hr unauthenticated quota). Dated like upstream lines.
  if ! grep -qiE "gh-rate: [0-9]+/[0-9]+ .*($TODAY|$YEST)" "$RELAY"; then
    echo "FAIL: NOT COMPLETE -- relay missing fresh 'gh-rate: <remaining>/<limit> <today-UTC-date>' line (prove gh api token usage via gh api rate_limit)"
    FAIL=1
  else
    echo "PASS: gh-rate token-provenance line present"
  fi
  # ALWAYS-LIVE (2026-09-22): every package must ALSO carry a fresh
  # `upstream: <pkg> ... <today-UTC-date>` live-check line. The date proves the
  # check ran this run - lines dated any other day are recycled evidence.
  missing_upstream=0
  while IFS= read -r spec; do
    pkg=$(basename "$spec" .nix)
    if ! grep -qiE "upstream: $pkg .*($TODAY|$YEST)" "$RELAY"; then
      echo "FAIL: NOT COMPLETE -- package '$pkg' has no fresh 'upstream: $pkg ... <today-UTC-date>' live-check line this run"
      missing_upstream=$((missing_upstream+1))
    fi
  done < <(find pkgs -maxdepth 1 -name '*.nix')
  if [[ "$missing_upstream" -gt 0 ]]; then
    FAIL=1
  else
    echo "PASS: all $npkgs packages carry fresh upstream live-check lines"
  fi
else
  echo "FAIL: $RELAY missing"
  FAIL=1
fi
bad=0
for nix in pkgs/*.nix; do
  [[ -f "$nix" ]] || continue
  if ! grep -q "pname.*=" "$nix" 2>/dev/null; then echo "FAIL: $nix missing pname"; bad=$((bad+1)); fi
done
if [[ "$bad" -gt 0 ]]; then echo "FAIL: $bad nix files malformed"; FAIL=1; fi
if [[ "$FAIL" -ne 0 ]]; then echo "FAIL: NOT COMPLETE -- agent must continue working"; exit 1; fi
echo "PASS: VERIFICATION PASSED -- all $npkgs nix teardown + upstream + evidence present"
exit 0
