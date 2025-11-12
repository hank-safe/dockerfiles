FROM alpine AS builder

ARG app_version=2.2.8

RUN apk --no-cache add \
        binutils \
        file \
        file-dev \
        gcc \
        glib \
        glib-dev \
        ipset \
        ipset-dev \
        iptables \
        iptables-dev \
        libmnl-dev \
        libnftnl-dev \
        libnl3 \
        libnl3-dev \
        libnl3-static \
        make \
        musl-dev \
        net-snmp-dev \
        openssl \
        openssl-dev \
        openssl-libs-static \
        pcre2 \
        pcre2-dev \
        autoconf \
        automake zlib-static  alpine-sdk linux-headers  libmnl-static git

WORKDIR /build

RUN wget -O keepalived.tar.gz https://www.keepalived.org/software/keepalived-${app_version}.tar.gz && \
    tar xf keepalived.tar.gz && \
    cd keepalived-${app_version} && \
    ./autogen.sh && \
    CFLAGS='-static -s' LDFLAGS=-static ./configure  --disable-dynamic-linking \
    --prefix=/usr \
    --exec-prefix=/usr \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin \
    --sysconfdir=/etc \
    --datadir=/usr/share \
    --localstatedir=/var \
    --mandir=/usr/share/man \
    --enable-bfd \
    --enable-snmp \
    --enable-snmp-rfc \
    --enable-nftables \
    --enable-regex \
    --enable-json  --with-init=systemd --enable-vrrp --enable-libnl-dynamic && \
    make -j && \
    make DESTDIR=/packs/keepalived install && \
    strip /packs/keepalived/usr/sbin/keepalived && \
    chown -R $(id -u):$(id -g) /packs/keepalived

WORKDIR /packs

FROM alpine

COPY --from=builder /packs /packs

WORKDIR /packs

