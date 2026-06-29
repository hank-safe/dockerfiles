FROM alpine AS builder

ARG app_version=0.12.20

RUN apk add build-base gcc musl-dev 

WORKDIR /build

RUN wget -O lrzsz.tar.gz  https://www.ohse.de/uwe/releases/lrzsz-${app_version}.tar.gz && \
    tar xf lrzsz.tar.gz && \
    cd lrzsz-${app_version} && \
    CFLAGS=-static  ./configure --prefix=/packs/lrzsz --disable-nls LDFLAGS="-static" && \
    make -j2 && \
    make install && \
    strip /packs/lrzsz/bin/lrz && \
    strip /packs/lrzsz/bin/lsz && \
    chown -R $(id -u):$(id -g) /packs/lrzsz

WORKDIR /packs

FROM alpine

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}

WORKDIR /packs

