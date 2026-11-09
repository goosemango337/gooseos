#!/usr/bin/env bash
set -euo pipefail

# Goose OS live ISO build (run on Linux: Ubuntu/Debian). Requires sudo/root for live-build.
# Usage: sudo ./scripts/build.sh

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "ERROR: This build must run on Linux (Debian/Ubuntu recommended)." >&2
  echo "Use WSL2, a Linux VM, or a Linux host, then install live-build dependencies." >&2
  exit 1
fi

if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
  echo "ERROR: Run as root (sudo ./scripts/build.sh)." >&2
  exit 1
fi

export LB_BUILD_WITH_CHROOT=true

lb clean --purge || true
rm -rf .build config/.build || true

lb config \
  --mode debian \
  --distribution bookworm \
  --architectures amd64 \
  --archive-areas "main contrib non-free non-free-firmware" \
  --debian-installer none \
  --bootappend-live "boot=live components quiet splash noeject" \
  --memtest none \
  --binary-images iso-hybrid \
  --iso-application "Goose OS" \
  --iso-publisher "Goose OS Project" \
  --iso-volume "GOOSE_OS" \
  --apt-recommends true \
  --firmware-chroot true \
  --firmware-binary true

lb build 2>&1 | tee build.log

mkdir -p artifacts
shopt -s nullglob
isos=( *.iso *.hybrid.iso )
if (( ${#isos[@]} == 0 )); then
  echo "ERROR: build finished but no ISO was found. Check build.log." >&2
  exit 1
fi
latest=$(ls -t "${isos[@]}" | head -n1)
dest="artifacts/goose-os-amd64.hybrid.iso"
cp -f "$latest" "$dest"
echo "ISO ready: $ROOT/$dest"
