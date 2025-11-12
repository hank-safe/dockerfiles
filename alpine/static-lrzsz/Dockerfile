FROM alpine AS builder

ARG app_version=0.12.20

RUN apk add build-base gcc musl-dev 

WORKDIR /build

RUN wget -O lrzsz.tar.gz  https://www.ohse.de/uwe/releases/lrzsz-${app_version}.tar.gz && \
    tar xf lrzsz.tar.gz && \
    cd lrzsz-${app_version} && \
    CFLAGS=-static  ./configure --prefix=/packs/lrzsz LDFLAGS="-static" && \
    make -j && \
    make install && \
    strip /packs/lrzsz/bin/rz && \
    strip /packs/lrzsz/bin/sz && \
    chown -R $(id -u):$(id -g) /packs/lrzsz

WORKDIR /packs

FROM alpine

COPY --from=builder /packs /packs

WORKDIR /packs

