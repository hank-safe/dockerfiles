FROM alpine AS builder
# 3.36是验证可以编译的，4.2验证失败
ARG app_version=3.36

RUN apk add build-base gcc musl-dev && \
    apk add linux-headers zlib-dev openssl-dev libaio-dev

WORKDIR /build

RUN wget -O fio.tar.gz  https://github.com/axboe/fio/archive/refs/tags/fio-${app_version}.tar.gz && \
    tar xf fio.tar.gz && \
    cd fio-fio-${app_version} && \
    ./configure --prefix=/packs/fio --build-static && \
    make && \
    make install && \
    strip /packs/fio/bin/fio && \
    chown -R $(id -u):$(id -g) /packs/fio

WORKDIR /packs

FROM alpine

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}


WORKDIR /packs

