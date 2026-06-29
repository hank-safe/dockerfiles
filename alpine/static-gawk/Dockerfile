FROM alpine  AS builder

ARG app_version=5.3.2

RUN apk add gcc musl-dev make automake autoconf ncurses-dev build-base && \
    apk add ncurses-static linux-headers

WORKDIR /build

RUN wget -O gawk.tar.gz  https://ftp.gnu.org/gnu/gawk/gawk-${app_version}.tar.gz && \
    tar xf gawk.tar.gz && \
    cd gawk-${app_version} && \
    LDFLAGS="-static" PKG_CONFIG="pkg-config --static" ./configure --prefix=/packs/gawk && \
    make -j && \
    make install && \
    strip /packs/gawk/bin/gawk && \
    chown -R $(id -u):$(id -g) /packs/gawk 

WORKDIR /packs

FROM alpine

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}


WORKDIR /packs
