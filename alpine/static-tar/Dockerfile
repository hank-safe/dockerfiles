FROM alpine AS builder

ARG app_version=1.35

RUN apk add build-base gcc musl-dev zlib-dev openssl-dev

WORKDIR /build

RUN wget -O tar.tar.gz http://ftp.gnu.org/gnu/tar/tar-${app_version}.tar.gz && \
    tar xf tar.tar.gz && \
    cd tar-${app_version} && \
    FORCE_UNSAFE_CONFIGURE=1  CFLAGS=-static ./configure --prefix /out/tar  LDFLAGS="-static" && \
    make -j && \
    make install && \
    strip /packs/tar/bin/tar && \
    chown -R $(id -u):$(id -g) /packs/tar

WORKDIR /packs

FROM alpine

COPY --from=builder /packs /packs

WORKDIR /packs

