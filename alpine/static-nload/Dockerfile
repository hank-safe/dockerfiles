FROM alpine AS builder

ARG app_version=0.7.4
ARG ALPINE_REPOSITORY=https://dl-cdn.alpinelinux.org/alpine

RUN sed -i "s#https://dl-cdn.alpinelinux.org/alpine#${ALPINE_REPOSITORY}#g" /etc/apk/repositories && \
    apk add --no-cache \
        autoconf \
        automake \
        build-base \
        ncurses-dev \
        ncurses-static

WORKDIR /build

ADD https://github.com/rolandriegel/nload/archive/refs/tags/v${app_version}.tar.gz /build/nload.tar.gz

RUN tar -xzf nload.tar.gz && \
    cd nload-${app_version} && \
    autoreconf -fi && \
    LDFLAGS="-static" ./configure \
        --prefix=/packs/nload \
        LIBS="-lncursesw -ltinfo" && \
    make -j2 && \
    make install && \
    strip /packs/nload/bin/nload && \
    ! ldd /packs/nload/bin/nload 2>&1 | grep -q '=>'

WORKDIR /packs

FROM alpine

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}

WORKDIR /packs
