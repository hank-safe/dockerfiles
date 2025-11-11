FROM alpine AS builder

ARG app_version=4.6

RUN apk add build-base libcap-dev texinfo nettle-dev gnutls-dev bash wget tar gcc make

WORKDIR /build

RUN wget https://chrony-project.org/releases/chrony-${app_version}.tar.gz && \
    tar zxf chrony-${app_version}.tar.gz && \
    rm -f chrony-${app_version}.tar.gz && \
    cd chrony-${app_version} && \
    CFLAGS='-static -g' LDFLAGS='-static -lm' ./configure --prefix=/packs/chrony --enable-scfilter --enable-ntp-signd && \
    make -j && \
    make install && \
    strip /packs/chrony/bin/chronyc && \
    chown -R $(id -u):$(id -g) /packs/chrony

FROM alpine

COPY --from=builder /packs /packs

WORKDIR /packs
