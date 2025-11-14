FROM alpine AS builder

ARG app_version=7.95

RUN apk add gcc g++ make automake autoconf  libtool linux-headers && \
    apk add openssl-libs-static zlib-static  libssh2-static openssl openssl-dev libpcap-dev  libssh2-dev 

WORKDIR /build

RUN wget -O nmap.tar.gz https://nmap.org/dist/nmap-${app_version}.tgz && \
    tar xf nmap.tar.gz && \
    cd nmap-${app_version} && \
    CFLAGS="-static" \
    LDFLAGS="-static" \
    ./configure --prefix /out/nmap  --with-openssl=/usr/include/openssl --with-libssh2 && \
    make -j2 V=1 && \
    make install && \
    strip /packs/nmap/bin/nmap && \
    strip /packs/nmap/bin/ncat && \
    strip /packs/nmap/bin/nping && \
    chown -R $(id -u):$(id -g) /packs/nmap 

WORKDIR /packs


FROM alpine

COPY --from=builder /packs /packs

WORKDIR /packs

