FROM alpine AS builder

ARG app_version=7.95

RUN apk add gcc g++ make automake autoconf  libtool linux-headers && \
    apk add openssl-libs-static zlib-static  libssh2-static openssl openssl-dev libpcap-dev  libssh2-dev 

WORKDIR /build

RUN wget -O nmap.tar.gz https://nmap.org/dist/nmap-${app_version}.tgz && \
    tar xf nmap.tar.gz && \
    cd nmap-${VERSION} && \
    CFLAGS=-static ./configure --prefix /packs/nmap  --with-openssl=/usr/include/openssl --with-libssh2 && \
    make -j && \
    make install && \
    strip /packs/nmap/bin/nmap && \
    strip /packs/nmap/bin/ncat && \
    strip /packs/nmap/bin/nping && \
    chown -R $(id -u):$(id -g) /packs/nmap 

WORKDIR /packs


FROM alpine

COPY --from=builder /packs /packs

WORKDIR /packs

