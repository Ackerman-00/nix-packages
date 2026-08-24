# Teardown Sweep Report

Repo type: **nix**. Sweep of **5** packages. Exit code is the verdict; this report is the receipt.
| Package | Distfile | Pinned | Internal | Status | Note |
|---|---|---|---|---|---|
| helium | helium-0.15.6.1-x86_64_linux.tar.xz | 0.15.6.1 | 0.15.6.1 | **OK** | tar runtime probe chrome --version: Helium 0.15.6.1 (Chromium 151.0.7922.169) \| pinned 0.15.6.1 \| internal 0.15.6.1 |
| helium | helium-0.15.6.1-arm64_linux.tar.xz | 0.15.6.1 |  | **SOURCE-OK** | tar extracted, no version evidence found \| hash hash-OK \| source tarball (version = PV by construction) |
| opencode-desktop | opencode-desktop-linux-amd64.deb | 1.18.21 | 1.18.21 | **OK** | deb pkg=opencode (control control.tar.xz) \| pinned 1.18.21 \| internal 1.18.21 |
| opencode-desktop | opencode-desktop-linux-arm64.deb | 1.18.21 | 1.18.21 | **OK** | deb pkg=opencode (control control.tar.xz) \| pinned 1.18.21 \| internal 1.18.21 |
| protonplus | ProtonPlus-0.6.4-anylinux-x86_64.AppImage | 0.6.4 | 0.6.4 | **OK** | AppImage 0.6.4 (com.vysp3r.ProtonPlus.desktop) \| pinned 0.6.4 \| internal 0.6.4 |
| protonplus | ProtonPlus-0.6.4-anylinux-aarch64.AppImage | 0.6.4 |  | **OK** | AppImage teardown error: [Errno 8] Exec format error: '/tmp/teardown-sweep/distfiles/ProtonPlus-0.6.4-anylinux-aarch64.AppImage' \| hash hash-OK \| cross-arch artifact (aarch64), hash-verified; not executable on x86_64 host |
| rootapp | Root.AppImage | 0.9.127 | 0.9.127 | **OK** | AppImage 0.9.127 (Root.desktop) \| pinned 0.9.127 \| internal 0.9.127 |
| rootapp | Root.AppImage | 0.9.127 |  | **OK** | AppImage teardown error: [Errno 8] Exec format error: '/tmp/teardown-sweep/distfiles/Root_4.AppImage' \| hash hash-OK \| cross-arch artifact (aarch64), hash-verified; not executable on x86_64 host |
| zen-browser | zen.linux-x86_64.tar.xz | 1.21.15b | 1.21.15b | **OK** | tar application.ini=1.21.15b (zen/application.ini) \| pinned 1.21.15b \| internal 1.21.15b |
| zen-browser | zen.linux-aarch64.tar.xz | 1.21.15b | 1.21.15b | **OK** | tar application.ini=1.21.15b (zen/application.ini) \| pinned 1.21.15b \| internal 1.21.15b |
| helium | upstream github.com/imputnet/helium-linux | 0.15.6.1 | 0.15.6.1 | **OK** | at upstream latest 0.15.6.1 [releases/latest] |
| opencode-desktop | upstream github.com/anomalyco/opencode | 1.18.21 | v1.18.21 | **OK** | at upstream latest v1.18.21 [releases/latest] |
| protonplus | upstream github.com/Vysp3r/ProtonPlus | 0.6.4 | v0.6.4 | **OK** | at upstream latest v0.6.4 [releases/latest] |
| zen-browser | upstream github.com/zen-browser/desktop | 1.21.15b | 1.21.15b | **OK** | at upstream latest 1.21.15b [releases/latest] |
| LIBYEAR | freshness | 0.01 yr | 1 pkgs | **METRIC** | threshold=20 libyears |

**Verdict: PASS** (0 failure(s))
