FROM alpine

ARG app_version=4.99.4

RUN apk add gcc g++ make automake libpcap-dev

WORKDIR /build

RUN wget -O tcpdump.tar.gz https://www.tcpdump.org/release/tcpdump-${app_version}.tar.gz && \
    tar xf tcpdump.tar.gz && \
    cd tcpdump-${VERSION} && \
    CFLAGS=-static ./configure --prefix /packs/tcpdump --without-crypto && \
    make -j && \
    make install && \
    strip /out/tcpdump/bin/tcpdump && \
    chown -R $(id -u):$(id -g) /packs/tcpdump

WORKDIR /packs
