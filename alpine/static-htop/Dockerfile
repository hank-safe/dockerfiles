FROM alpine AS builder

ARG app_version=3.4.1

RUN apk add gcc musl-dev make automake autoconf ncurses-dev build-base && \
    apk add ncurses ncurses-static libcap-dev libcap-static

WORKDIR /build

RUN wget -O htop.tar.gz  https://github.com/htop-dev/htop/releases/download/${app_version}/htop-${app_version}.tar.xz && \
    tar xf htop.tar.gz && \
    cd htop-${app_version} && \
    ./autogen.sh && \
    CFLAGS="-O0 -g3"  ./configure --enable-static --disable-shared --prefix=/packs/htop && \
    make -j  && \
    make install && \
    strip /packs/htop/bin/htop && \
    chown -R $(id -u):$(id -g) /packs/htop

WORKDIR /packs

FROM alpine

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}


WORKDIR /packs

