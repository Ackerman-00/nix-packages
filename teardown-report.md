# Teardown Sweep Report

Repo type: **nix**. Sweep of **7** packages. Exit code is the verdict; this report is the receipt.
| Package | Distfile | Pinned | Internal | Status | Note |
|---|---|---|---|---|---|
| helium | helium-0.16.6.1-x86_64_linux.tar.xz | 0.16.6.1 | 0.16.6.1 | **OK** | tar runtime probe chrome --version: Helium 0.16.6.1 (Chromium 152.0.7977.82) \| pinned 0.16.6.1 \| internal 0.16.6.1 |
| helium | helium-0.16.6.1-arm64_linux.tar.xz | 0.16.6.1 |  | **SOURCE-OK** | tar extracted, no version evidence found \| hash hash-OK \| source tarball (version = PV by construction) |
| mixtapes | live m-obeid/Mixtapes | f68ffef8733b | f68ffef8733b | **OK** | live m-obeid/Mixtapes pin f68ffef8733b vs upstream f68ffef8733b |
| opencode-desktop | opencode-desktop-linux-amd64.deb | 1.18.30 | 1.18.30 | **OK** | deb pkg=opencode (control control.tar.xz) \| pinned 1.18.30 \| internal 1.18.30 |
| opencode-desktop | opencode-desktop-linux-arm64.deb | 1.18.30 | 1.18.30 | **OK** | deb pkg=opencode (control control.tar.xz) \| pinned 1.18.30 \| internal 1.18.30 |
| protonplus | ProtonPlus-0.6.7-anylinux-x86_64.AppImage | 0.6.7 | 0.6.7 | **OK** | AppImage 0.6.7 (com.vysp3r.ProtonPlus.desktop) \| pinned 0.6.7 \| internal 0.6.7 |
| protonplus | ProtonPlus-0.6.7-anylinux-aarch64.AppImage | 0.6.7 |  | **OK** | AppImage teardown error: [Errno 8] Exec format error: '/tmp/opencode/sweep-run4/distfiles/ProtonPlus-0.6.7-anylinux-aarch64.AppImage' \| hash hash-OK \| cross-arch artifact (aarch64), hash-verified; not executable on x86_64 host |
| rootapp | Root.AppImage | 0.9.129 | 0.9.129 | **OK** | AppImage 0.9.129 (Root.desktop) \| pinned 0.9.129 \| internal 0.9.129 |
| rootapp | Root.AppImage | 0.9.129 |  | **OK** | AppImage teardown error: [Errno 8] Exec format error: '/tmp/opencode/sweep-run4/distfiles/Root_2.AppImage' \| hash hash-OK \| cross-arch artifact (aarch64), hash-verified; not executable on x86_64 host |
| splayer-next | splayer-next-1.1.0-x64.tar.gz | 1.1.0 | 1.1.0 | **OK** | tar asar=1.1.0 (splayer-next-1.1.0-x64/resources/app.asar) \| pinned 1.1.0 \| internal 1.1.0 |
| splayer-next | splayer-next-1.1.0-arm64.tar.gz | 1.1.0 | 1.1.0 | **OK** | tar asar=1.1.0 (splayer-next-1.1.0-arm64/resources/app.asar) \| pinned 1.1.0 \| internal 1.1.0 |
| zen-browser | zen.linux-x86_64.tar.xz | 1.22b | 1.22b | **OK** | tar application.ini=1.22b (zen/application.ini) \| pinned 1.22b \| internal 1.22b |
| zen-browser | zen.linux-aarch64.tar.xz | 1.22b | 1.22b | **OK** | tar application.ini=1.22b (zen/application.ini) \| pinned 1.22b \| internal 1.22b |
| helium | upstream github.com/imputnet/helium-linux | 0.16.6.1 | 0.16.6.1 | **OK** | at upstream latest 0.16.6.1 [tag; releases/latest pointer stale at 0.16.5.1] |
| opencode-desktop | upstream github.com/anomalyco/opencode | 1.18.30 | v1.18.30 | **OK** | at upstream latest v1.18.30 [releases/latest] |
| protonplus | upstream github.com/Vysp3r/ProtonPlus | 0.6.7 | v0.6.7 | **OK** | at upstream latest v0.6.7 [releases/latest] |
| splayer-next | upstream github.com/SPlayer-Dev/SPlayer-Next | 1.1.0 | v1.1.0 | **OK** | at upstream latest v1.1.0 [releases/latest] |
| zen-browser | upstream github.com/zen-browser/desktop | 1.22b | 1.22b | **OK** | at upstream latest 1.22b [releases/latest] |
| LIBYEAR | freshness | 0.00 yr | 0 pkgs | **METRIC** | threshold=20 libyears |

**Verdict: PASS** (0 failure(s))
