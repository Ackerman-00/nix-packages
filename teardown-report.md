# Teardown Sweep Report

Repo type: **nix**. Sweep of **6** packages. Exit code is the verdict; this report is the receipt.
| Package | Distfile | Pinned | Internal | Status | Note |
|---|---|---|---|---|---|
| helium | helium-0.16.5.1-x86_64_linux.tar.xz | 0.16.5.1 | 0.16.5.1 | **OK** | tar runtime probe chrome --version: Helium 0.16.5.1 (Chromium 152.0.7977.82) \| pinned 0.16.5.1 \| internal 0.16.5.1 |
| helium | helium-0.16.5.1-arm64_linux.tar.xz | 0.16.5.1 |  | **SOURCE-OK** | tar extracted, no version evidence found \| hash hash-OK \| source tarball (version = PV by construction) |
| mixtapes | live m-obeid/Mixtapes | c48756eebd83 | c48756eebd83 | **OK** | live m-obeid/Mixtapes pin c48756eebd83 vs upstream c48756eebd83 |
| opencode-desktop | opencode-desktop-linux-amd64.deb | 1.18.29 | 1.18.29 | **OK** | deb pkg=opencode (control control.tar.xz) \| pinned 1.18.29 \| internal 1.18.29 |
| opencode-desktop | opencode-desktop-linux-arm64.deb | 1.18.29 | 1.18.29 | **OK** | deb pkg=opencode (control control.tar.xz) \| pinned 1.18.29 \| internal 1.18.29 |
| protonplus | ProtonPlus-0.6.6-anylinux-x86_64.AppImage | 0.6.6 | 0.6.6 | **OK** | AppImage 0.6.6 (com.vysp3r.ProtonPlus.desktop) \| pinned 0.6.6 \| internal 0.6.6 |
| protonplus | ProtonPlus-0.6.6-anylinux-aarch64.AppImage | 0.6.6 |  | **OK** | AppImage teardown error: [Errno 8] Exec format error: '/tmp/opencode/sweep-verify/distfiles/ProtonPlus-0.6.6-anylinux-aarch64.AppImage' \| hash hash-OK \| cross-arch artifact (aarch64), hash-verified; not executable on x86_64 host |
| rootapp | Root.AppImage | 0.9.129 | 0.9.129 | **OK** | AppImage 0.9.129 (Root.desktop) \| pinned 0.9.129 \| internal 0.9.129 |
| rootapp | Root.AppImage | 0.9.129 |  | **OK** | AppImage teardown error: [Errno 8] Exec format error: '/tmp/opencode/sweep-verify/distfiles/Root_2.AppImage' \| hash hash-OK \| cross-arch artifact (aarch64), hash-verified; not executable on x86_64 host |
| zen-browser | zen.linux-x86_64.tar.xz | 1.21.16b | 1.21.16b | **OK** | tar application.ini=1.21.16b (zen/application.ini) \| pinned 1.21.16b \| internal 1.21.16b |
| zen-browser | zen.linux-aarch64.tar.xz | 1.21.16b | 1.21.16b | **OK** | tar application.ini=1.21.16b (zen/application.ini) \| pinned 1.21.16b \| internal 1.21.16b |
| helium | upstream github.com/imputnet/helium-linux | 0.16.5.1 | 0.16.5.1 | **OK** | at upstream latest 0.16.5.1 [tag; releases/latest pointer stale at 0.16.4.1] |
| opencode-desktop | upstream github.com/anomalyco/opencode | 1.18.29 | v1.18.29 | **OK** | at upstream latest v1.18.29 [releases/latest] |
| protonplus | upstream github.com/Vysp3r/ProtonPlus | 0.6.6 | v0.6.6 | **OK** | at upstream latest v0.6.6 [releases/latest] |
| zen-browser | upstream github.com/zen-browser/desktop | 1.21.16b | 1.21.16b | **OK** | at upstream latest 1.21.16b [releases/latest] |
| LIBYEAR | freshness | 0.00 yr | 0 pkgs | **METRIC** | threshold=20 libyears |

**Verdict: PASS** (0 failure(s))
