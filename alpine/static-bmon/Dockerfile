FROM alpine AS builder

ARG app_version=4.0

RUN apk add gcc musl-dev make automake autoconf  build-base && \
    apk add ncurses ncurses-static ncurses-dev libcap-dev libcap-static  confuse-dev libnl3-dev \
    libnl3-static  confuse-static pkgconfig

WORKDIR /build

RUN wget -O bmon.tar.gz  https://github.com/tgraf/bmon/releases/download/v${app_version}/bmon-${app_version}.tar.gz && \
    tar xf bmon.tar.gz && \
    cd bmon-${app_version} && \
    CFLAGS="-O0 -g3" ./configure --prefix=/packs/bmon LIBS="-static" && \
    make -j && \
    make install && \
    strip /packs/bmon/bin/bmon && \
    chown -R $(id -u):$(id -g) /packs/bmon 

WORKDIR /packs

FROM alpine

COPY --from=builder /packs /packs

WORKDIR /packs
