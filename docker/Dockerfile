FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    live-build debootstrap squashfs-tools xorriso isolinux \
    wget curl git ca-certificates rsync sudo \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /work
COPY . /work

RUN chmod +x /work/scripts/build.sh
CMD ["/work/scripts/build.sh"]
