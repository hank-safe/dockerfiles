FROM alpine AS builder

ARG app_version=3.4.1

RUN apk add build-base gcc musl-dev zlib-dev openssl-dev && \
    apk add openssl-libs-static zlib-static  libssh2-static openssl openssl-dev libpcap-dev  libssh2-dev  && \
    apk add zstd-static zstd-dev xxhash-dev lz4-static lz4-dev

WORKDIR /build

RUN wget -O rsync.tar.gz https://download.samba.org/pub/rsync/src/rsync-${app_version}.tar.gz && \
    tar xf rsync.tar.gz && \
    cd rsync-${app_version} && \
    CFLAGS=-static ./configure --prefix /packs/rsync  LDFLAGS="-static" --disable-xxhash && \
    make -j && \
    make install && \
    strip /packs/rsync/bin/rsync && \
    chown -R $(id -u):$(id -g) /packs/rsync

WORKDIR /packs

FROM alpine

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}


WORKDIR /packs

