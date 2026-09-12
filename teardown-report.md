# Teardown Sweep Report

Repo type: **nix**. Sweep of **7** packages. Exit code is the verdict; this report is the receipt.
| Package | Distfile | Pinned | Internal | Status | Note |
|---|---|---|---|---|---|
| helium | helium-0.17.0.1-x86_64_linux.tar.xz | 0.17.0.1 | 0.17.0.1 | **OK** | tar runtime probe chrome --version: Helium 0.17.0.1 (Chromium 153.0.8010.36) \| pinned 0.17.0.1 \| internal 0.17.0.1 |
| helium | helium-0.17.0.1-arm64_linux.tar.xz | 0.17.0.1 |  | **SOURCE-OK** | tar extracted, no version evidence found \| hash hash-OK \| source tarball (version = PV by construction) |
| mixtapes | live m-obeid/Mixtapes | 00f47077627b | 00f47077627b | **OK** | live m-obeid/Mixtapes pin 00f47077627b vs upstream 00f47077627b |
| opencode-desktop | opencode-desktop-linux-amd64.deb | 1.18.30 | 1.18.30 | **OK** | deb pkg=opencode (control control.tar.xz) \| pinned 1.18.30 \| internal 1.18.30 |
| opencode-desktop | opencode-desktop-linux-arm64.deb | 1.18.30 | 1.18.30 | **OK** | deb pkg=opencode (control control.tar.xz) \| pinned 1.18.30 \| internal 1.18.30 |
| protonplus | ProtonPlus-0.6.8-anylinux-x86_64.AppImage | 0.6.8 | 0.6.8 | **OK** | AppImage 0.6.8 (com.vysp3r.ProtonPlus.desktop) \| pinned 0.6.8 \| internal 0.6.8 |
| protonplus | ProtonPlus-0.6.8-anylinux-aarch64.AppImage | 0.6.8 |  | **OK** | AppImage teardown error: [Errno 8] Exec format error: '/tmp/opencode/sweep-34717291522b/distfiles/ProtonPlus-0.6.8-anylinux-aarch64.AppImage' \| hash hash-OK \| cross-arch artifact (aarch64), hash-verified; not executable on x86_64 host |
| rootapp | Root.AppImage | 0.9.130 | 0.9.130 | **OK** | AppImage 0.9.130 (Root.desktop) \| pinned 0.9.130 \| internal 0.9.130 |
| rootapp | Root.AppImage | 0.9.130 |  | **OK** | AppImage teardown error: [Errno 8] Exec format error: '/tmp/opencode/sweep-34717291522b/distfiles/Root_2.AppImage' \| hash hash-OK \| cross-arch artifact (aarch64), hash-verified; not executable on x86_64 host |
| splayer-next | splayer-next-1.1.0-x64.tar.gz | 1.1.0 | 1.1.0 | **OK** | tar asar=1.1.0 (splayer-next-1.1.0-x64/resources/app.asar) \| pinned 1.1.0 \| internal 1.1.0 |
| splayer-next | splayer-next-1.1.0-arm64.tar.gz | 1.1.0 | 1.1.0 | **OK** | tar asar=1.1.0 (splayer-next-1.1.0-arm64/resources/app.asar) \| pinned 1.1.0 \| internal 1.1.0 |
| zen-browser | zen.linux-x86_64.tar.xz | 1.22.1b | 1.22.1b | **OK** | tar application.ini=1.22.1b (zen/application.ini) \| pinned 1.22.1b \| internal 1.22.1b |
| zen-browser | zen.linux-aarch64.tar.xz | 1.22.1b | 1.22.1b | **OK** | tar application.ini=1.22.1b (zen/application.ini) \| pinned 1.22.1b \| internal 1.22.1b |
| helium | upstream github.com/imputnet/helium-linux | 0.17.0.1 | 0.17.0.1 | **OK** | at upstream latest 0.17.0.1 [releases/latest] |
| opencode-desktop | upstream github.com/anomalyco/opencode | 1.18.30 | v1.18.30 | **OK** | at upstream latest v1.18.30 [releases/latest] |
| protonplus | upstream github.com/Vysp3r/ProtonPlus | 0.6.8 | v0.6.8 | **OK** | at upstream latest v0.6.8 [releases/latest] |
| splayer-next | upstream github.com/SPlayer-Dev/SPlayer-Next | 1.1.0 | v1.1.0 | **OK** | at upstream latest v1.1.0 [releases/latest] |
| zen-browser | upstream github.com/zen-browser/desktop | 1.22.1b | 1.22.1b | **OK** | at upstream latest 1.22.1b [releases/latest] |
| LIBYEAR | freshness | 0.00 yr | 0 pkgs | **METRIC** | threshold=20 libyears |

**Verdict: PASS** (0 failure(s))
