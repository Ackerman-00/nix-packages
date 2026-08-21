# Teardown Sweep Report

Repo type: **nix**. Sweep of **5** packages. Exit code is the verdict; this report is the receipt.
| Package | Distfile | Pinned | Internal | Status | Note |
|---|---|---|---|---|---|
| helium | helium-0.15.6.1-x86_64_linux.tar.xz | 0.15.6.1 | 0.15.6.1 | **OK** | tar runtime probe chrome --version: Helium 0.15.6.1 (Chromium 151.0.7922.169) \| pinned 0.15.6.1 \| internal 0.15.6.1 |
| helium | helium-0.15.6.1-arm64_linux.tar.xz | 0.15.6.1 |  | **SOURCE-OK** | tar extracted, no version evidence found \| hash hash-OK \| source tarball (version = PV by construction) |
| opencode-desktop | opencode-desktop-linux-amd64.deb | v1.18.20 | 1.18.20 | **OK** | deb pkg=opencode (control control.tar.xz) \| pinned v1.18.20 \| internal 1.18.20 |
| opencode-desktop | opencode-desktop-linux-arm64.deb | v1.18.20 | 1.18.20 | **OK** | deb pkg=opencode (control control.tar.xz) \| pinned v1.18.20 \| internal 1.18.20 |
| protonplus | ProtonPlus-0.6.4-anylinux-x86_64.AppImage | 0.6.4 | 0.6.4 | **OK** | AppImage 0.6.4 (com.vysp3r.ProtonPlus.desktop) \| pinned 0.6.4 \| internal 0.6.4 |
| protonplus | ProtonPlus-0.6.4-anylinux-aarch64.AppImage | 0.6.4 |  | **OK** | AppImage teardown error: [Errno 8] Exec format error: '/tmp/teardown-sweep/distfiles/ProtonPlus-0.6.4-anylinux-aarch64.AppImage' \| hash hash-OK \| cross-arch artifact (aarch64), hash-verified; not executable on x86_64 host |
| rootapp | Root.AppImage | latest | 0.9.127 | **OK** | AppImage 0.9.127 (Root.desktop) \| hash hash-OK \| pinned placeholder 'latest', internal 0.9.127 authoritative \| pinned latest \| internal 0.9.127 |
| rootapp | Root.AppImage | latest |  | **OK** | AppImage teardown error: [Errno 8] Exec format error: '/tmp/teardown-sweep/distfiles/Root.AppImage.9247a308' \| hash hash-OK \| cross-arch artifact (aarch64), hash-verified; not executable on x86_64 host |
| zen-browser | zen.linux-x86_64.tar.xz | 1.21.15b | 1.21.15b | **OK** | tar application.ini=1.21.15b (zen/application.ini) \| pinned 1.21.15b \| internal 1.21.15b |
| zen-browser | zen.linux-aarch64.tar.xz | 1.21.15b | 1.21.15b | **OK** | tar application.ini=1.21.15b (zen/application.ini) \| pinned 1.21.15b \| internal 1.21.15b |
| helium | upstream github.com/imputnet/helium-linux | 0.15.6.1 | 0.15.6.1 | **OK** | at upstream latest 0.15.6.1 [releases/latest] |
| opencode-desktop | upstream github.com/anomalyco/opencode | v1.18.20 | v1.18.20 | **OK** | at upstream latest v1.18.20 [releases/latest] |
| protonplus | upstream github.com/Vysp3r/ProtonPlus | 0.6.4 | v0.6.4 | **OK** | at upstream latest v0.6.4 [releases/latest] |
| zen-browser | upstream github.com/zen-browser/desktop | 1.21.15b | 1.21.15b | **OK** | at upstream latest 1.21.15b [releases/latest] |

**Verdict: PASS** (0 failure(s))
