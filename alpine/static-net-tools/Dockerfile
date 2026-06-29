FROM alpine AS builder

ARG app_version=2.10

RUN apk add build-base gcc musl-dev zlib-dev openssl-dev && \
    apk add make linux-headers && \
    apk add bash

WORKDIR /packs

RUN wget -O net.tar.gz https://downloads.sourceforge.net/project/net-tools/net-tools-${app_version}.tar.xz && \
    tar xf net.tar.gz && \
    cd net-tools-${app_version} && \
    sed -i 's/^CFLAGS=.*/CFLAGS= -O2 -static/' Makefile && \
    sed -i 's/^LDFLAGS=.*/LDFLAGS= -static/' Makefile && \
    export LDFLAGS=-static && \
    export CFLAGS=-static && \
    yes "" | make && \
    make DESTDIR=/packs/net-tools install


FROM alpine

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}

WORKDIR /packs

