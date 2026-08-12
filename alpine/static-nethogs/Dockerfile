FROM alpine AS builder

ARG app_version=0.8.8
ARG ALPINE_REPOSITORY=https://dl-cdn.alpinelinux.org/alpine

RUN sed -i "s#https://dl-cdn.alpinelinux.org/alpine#${ALPINE_REPOSITORY}#g" /etc/apk/repositories && \
    apk add --no-cache \
        build-base \
        libpcap-dev \
        linux-headers \
        ncurses-dev \
        ncurses-static

WORKDIR /build

ADD https://github.com/raboof/nethogs/archive/refs/tags/v${app_version}.tar.gz /build/nethogs.tar.gz

RUN tar -xzf nethogs.tar.gz && \
    cd nethogs-${app_version} && \
    make -j2 nethogs \
        VERSION=${app_version} \
        LDFLAGS="-static" \
        NCURSES_LIBS="-lncursesw -ltinfo" && \
    make install \
        VERSION=${app_version} \
        PREFIX=/packs/nethogs \
        LDFLAGS="-static" \
        NCURSES_LIBS="-lncursesw -ltinfo" && \
    strip /packs/nethogs/sbin/nethogs

WORKDIR /packs

FROM alpine

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}

WORKDIR /packs
