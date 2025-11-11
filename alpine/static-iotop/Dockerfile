FROM alpine AS builder

ARG app_version=1.29

RUN apk add gcc musl-dev make automake autoconf ncurses-dev build-base && \
    apk add ncurses-static linux-headers xz

WORKDIR /build

RUN wget -O iotop.tar.gz  https://github.com/Tomas-M/iotop/releases/download/v${app_version}/iotop-${app_version}.tar.xz && \
    tar xf iotop.tar.gz && \
    cd iotop-${app_version} && \
    CFLAGS=-static DESTDIR=/packs/iotop make install && \
    strip /packs/iotop/usr/sbin/iotop && \
    chown -R $(id -u):$(id -g) /packs/iotop

WORKDIR /packs

FROM alpine

COPY --from=builder /packs /packs

WORKDIR /packs

