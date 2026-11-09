# Goose OS (macOS Sonoma-inspired) — VirtualBox Live ISO

A Debian-based live ISO project themed to resemble **macOS Sonoma** (UI inspiration only). Built for **VirtualBox** testing and meant to be **built on Linux**.

> Not affiliated with Apple. macOS and Sonoma are Apple trademarks. This project uses open-source themes/assets and does not include Apple proprietary software or artwork.

## What this produces
- A bootable **amd64 hybrid ISO** (`goose-os-*.iso`) you can attach to a VirtualBox VM.
- XFCE desktop preconfigured with a Sonoma-inspired look: dock, top panel, light/dark-friendly palette, rounded window chrome, and familiar controls (via open-source themes).

## Build requirements (Linux)
Build on **Ubuntu 22.04/24.04 or Debian 12** (recommended). You need root/sudo, ~15 GB free disk, and internet access.

```bash
sudo apt-get update
sudo apt-get install -y \
  live-build debootstrap squashfs-tools xorriso isolinux \
  wget curl git ca-certificates rsync
```

## Build
```bash
cd goose-os
chmod +x scripts/build.sh
sudo ./scripts/build.sh
```

Output: `artifacts/goose-os-amd64.hybrid.iso` (name may include a date).

## Quick build with Docker (on a Linux host)
If you prefer a containerized Linux build environment:
```bash
cd goose-os
docker build -t goose-os-builder -f docker/Dockerfile .
docker run --rm --privileged -v "$PWD/artifacts:/work/artifacts" goose-os-builder
```

## VirtualBox VM settings
- **Type/Version**: Linux / Debian (64-bit)
- **Firmware**: EFI (recommended) or BIOS; the hybrid ISO supports common setups
- **RAM**: 4096 MB+ (2048 MB minimum)
- **CPU**: 2+ cores
- **Video Memory**: 128 MB, **Graphics Controller**: VMSVGA
- **3D Acceleration**: optional; enable only if stable on your host
- **Storage**: attach the ISO to the optical drive; disk optional for live use
- **Network**: NAT

Boot the VM, choose *Goose OS Live* from the menu, and log in if prompted (live user/password depend on the live-config defaults; try empty password or `live`/`live`).

## Project layout
- `config/` — Debian live-build configuration (packages, hooks, chroot files)
- `config/includes.chroot/` — files copied into the live filesystem (themes, skel config)
- `config/hooks/live/` — scripts run during build to install/configure the UI
- `scripts/build.sh` — Linux build entrypoint
- `docker/` — optional containerized build

## Customization
- Packages: `config/package-lists/goose.list.chroot`
- UI/theme install: `config/hooks/live/0100-goose-ui.hook.chroot`
- Default user settings: `config/includes.chroot/etc/skel/`

## Status / limitations
- This repository generates the **build system and UI configuration**. The actual ISO must be produced by running the build on Linux (live-build requires a Linux environment).
- A Sonoma-like look is achieved with open-source components (XFCE + theme/dock configuration); it is an approximation, not a pixel-perfect replica.
- Hardware support, Secure Boot, and installer behavior depend on Debian live-build defaults and the packages you include.
