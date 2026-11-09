#!/usr/bin/env bash
set -euo pipefail
# Convenience wrapper for running the build on any Linux host.
# Produces: goose-os/artifacts/goose-os-amd64.hybrid.iso

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
mkdir -p artifacts

if command -v docker >/dev/null 2>&1; then
  echo "Building via Docker (Linux host with Docker required)..."
  docker build -t goose-os-builder -f docker/Dockerfile .
  docker run --rm --privileged -v "$ROOT/artifacts:/work/artifacts" goose-os-builder
  echo "Done. ISO in $ROOT/artifacts/"
  exit 0
fi

echo "Docker not found; running direct live-build. This must be Linux with live-build installed."
sudo ./scripts/build.sh
