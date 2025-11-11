FROM alpine

ARG app_version=8.11.0

RUN apk add build-base clang openssl-dev nghttp2-dev nghttp2-static libssh2-dev libssh2-static perl && \
    apk add openssl-libs-static zlib-static && \
    apk add gnupg

ENV CC=clang

WORKDIR /build

RUN wget https://curl.haxx.se/download/curl-${app_version}.tar.gz && \
    tar xzf curl-${app_version}.tar.gz && \
    cd curl-${app_version} && \
    LDFLAGS="-static" PKG_CONFIG="pkg-config --static" \
    ./configure --prefix /packs/curl --disable-shared --enable-static \
    --disable-ldap --enable-ipv6 --enable-unix-sockets \
    --with-ssl --with-libssh2 --disable-docs --disable-manual --without-libpsl && \
    make -j V=1 LDFLAGS="-static -all-static" && \
    make install && \
    strip /packs/curl/bin/curl 

WORKDIR /packs