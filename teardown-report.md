# Teardown Sweep Report

Repo type: **nix**. Sweep of **5** packages. Exit code is the verdict; this report is the receipt.
| Package | Distfile | Pinned | Internal | Status | Note |
|---|---|---|---|---|---|
| helium | helium-0.15.5.1-x86_64_linux.tar.xz | 0.15.5.1 | 0.15.5.1 | **OK** | tar runtime probe chrome --version: Helium 0.15.5.1 (Chromium 151.0.7922.137) \| pinned 0.15.5.1 \| internal 0.15.5.1 |
| helium | helium-0.15.5.1-arm64_linux.tar.xz | 0.15.5.1 |  | **OK** | tar extracted, no version evidence found \| hash hash-OK \| cross-arch artifact (aarch64), hash-verified; not executable on x86_64 host |
| opencode-desktop | opencode-desktop-linux-amd64.deb | v1.18.19 | 1.18.19 | **OK** | deb pkg=opencode (control control.tar.xz) \| pinned v1.18.19 \| internal 1.18.19 |
| opencode-desktop | opencode-desktop-linux-arm64.deb | v1.18.19 | 1.18.19 | **OK** | deb pkg=opencode (control control.tar.xz) \| pinned v1.18.19 \| internal 1.18.19 |
| protonplus | ProtonPlus-0.6.4-anylinux-x86_64.AppImage | 0.6.4 | 0.6.4 | **OK** | AppImage 0.6.4 (com.vysp3r.ProtonPlus.desktop) \| pinned 0.6.4 \| internal 0.6.4 |
| protonplus | ProtonPlus-0.6.4-anylinux-aarch64.AppImage | 0.6.4 |  | **OK** | AppImage teardown error: [Errno 8] Exec format error: '/tmp/opencode/sweep-nix/distfiles/ProtonPlus-0.6.4-anylinux-aarch64.AppImage' \| hash hash-OK \| cross-arch artifact (aarch64), hash-verified; not executable on x86_64 host |
| rootapp | Root.AppImage | latest | 0.9.127 | **OK** | AppImage 0.9.127 (Root.desktop) \| hash hash-OK \| pinned placeholder 'latest', internal 0.9.127 authoritative \| pinned latest \| internal 0.9.127 |
| zen-browser | zen.linux-x86_64.tar.xz | 1.21.15b | 1.21.15b | **OK** | tar application.ini=1.21.15b (zen/application.ini) \| pinned 1.21.15b \| internal 1.21.15b |
| zen-browser | zen.linux-aarch64.tar.xz | 1.21.15b | 1.21.15b | **OK** | tar application.ini=1.21.15b (zen/application.ini) \| pinned 1.21.15b \| internal 1.21.15b |

**Verdict: PASS** (0 failure(s))
