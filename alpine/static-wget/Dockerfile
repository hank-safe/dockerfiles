FROM alpine AS builder

ARG app_version=1.24.5

RUN apk add build-base gcc musl-dev linux-headers && \
    apk add \
        build-base \
        clang \
        openssl-dev \
        pcre-dev \
        zlib-dev \
        perl \
        openssl-libs-static \
        zlib-static

WORKDIR /build

RUN wget -O wget.tar.gz  https://ftp.gnu.org/gnu/wget/wget-${app_version}.tar.gz && \
    tar xf wget.tar.gz && \
    cd wget-${app_version} && \
    LDFLAGS="-static" PKG_CONFIG="pkg-config --static" ./configure --prefix=/packs/wget  --with-ssl=openssl --sysconfdir=/etc --disable-rpath && \
    make -j && \
    make install && \
    strip /packs/wget/bin/wget && \
    chown -R $(id -u):$(id -g) /packs/wget

WORKDIR /packs

FROM alpine

COPY --from=builder /packs /packs

WORKDIR /packs

