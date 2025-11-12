FROM ccr.ccs.tencentyun.com/hank997/alpine:3.20.3 AS builder

ARG app_version=7.95
ARG PCRE_VERSION=8.45

RUN apk add gcc g++ make automake autoconf  libtool linux-headers && \
    apk add openssl-libs-static zlib-static  libssh2-static openssl openssl-dev libpcap-dev  libssh2-dev 

WORKDIR /build

RUN wget -O pcre.tar.gz https://sourceforge.net/projects/pcre/files/pcre/${PCRE_VERSION}/pcre-${PCRE_VERSION}.tar.gz && \
    tar xf pcre.tar.gz && \
    cd pcre-${PCRE_VERSION} && \
    CFLAGS="-O2 -pipe" LDFLAGS="-static" ./configure \
        --prefix=/opt/static-pcre \
        --disable-shared \
        --enable-static \
        --disable-cpp \
        --enable-utf8 \
        --enable-unicode-properties && \
    make -j$(nproc) && \
    make install

RUN wget -O nmap.tar.gz https://nmap.org/dist/nmap-${app_version}.tgz && \
    tar xf nmap.tar.gz && \
    cd nmap-${app_version} && \
    CFLAGS=-static ./configure --prefix /packs/nmap  --with-openssl=/usr/include/openssl --with-libssh2 --with-libpcre=/opt/static-pcre && \
    make -j4 V=1 && \
    make install && \
    strip /packs/nmap/bin/nmap && \
    strip /packs/nmap/bin/ncat && \
    strip /packs/nmap/bin/nping && \
    chown -R $(id -u):$(id -g) /packs/nmap 

WORKDIR /packs


FROM ccr.ccs.tencentyun.com/hank997/alpine:3.20.3

COPY --from=builder /packs /packs

WORKDIR /packs

