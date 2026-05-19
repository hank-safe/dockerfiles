FROM alpine AS builder

# 后面的版本不允许静态编译了，9.16.50是最后一个支持静态编译的版本
# https://kb.isc.org/docs/changes-to-be-aware-of-when-moving-from-bind-916-to-918

ARG app_version=9.16.50

RUN apk add gcc g++ make libtool pkgconf perl perl-dev perl-doc python3 && \
    apk add openssl-dev openssl-libs-static && \
    apk add libuv-dev libuv-static && \
    apk add linux-headers musl-dev && \
    apk add userspace-rcu-dev userspace-rcu-static && \
    apk add nghttp2-dev nghttp2-static && \
    apk add libcap-dev libcap-static && \
    apk add ca-certificates

WORKDIR /build

RUN wget -O bind.tar.xz https://downloads.isc.org/isc/bind9/${app_version}/bind-${app_version}.tar.xz && \
    tar xf bind.tar.xz && \
    cd bind-${app_version} && \
    LDFLAGS="-static" \
    PKG_CONFIG="pkg-config --static" \
    ./configure \
        --prefix /packs/bind \
        --without-python \
        --enable-static \
        --with-openssl \
        --disable-linux-caps \
        --without-libjson \
        --without-libxml2 \
        --without-zlib \
        --without-lmdb \
        --without-gssapi \
        --without-readline \
        --without-idn \
        --enable-full-report && \
    make -j$(nproc) && \
    make install && \
    strip /packs/bind/bin/dig && \
    strip /packs/bind/bin/nslookup && \
    strip /packs/bind/bin/host && \
    strip /packs/bind/bin/nsupdate && \
    chown -R $(id -u):$(id -g) /packs/bind

WORKDIR /packs


FROM alpine

COPY --from=builder /packs /packs

WORKDIR /packs
