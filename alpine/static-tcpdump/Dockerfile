FROM alpine AS builder

ARG app_version=4.99.4

RUN apk add gcc g++ make automake libpcap-dev

WORKDIR /build

RUN wget -O tcpdump.tar.gz https://www.tcpdump.org/release/tcpdump-${app_version}.tar.gz && \
    tar xf tcpdump.tar.gz && \
    cd tcpdump-${app_version} && \
    CFLAGS=-static ./configure --prefix /packs/tcpdump --without-crypto && \
    make -j && \
    make install && \
    strip /packs/tcpdump/bin/tcpdump && \
    chown -R $(id -u):$(id -g) /packs/tcpdump

WORKDIR /packs

FROM alpine

COPY --from=builder /packs /packs

WORKDIR /packs

