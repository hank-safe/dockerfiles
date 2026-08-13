FROM alpine AS builder

ARG app_version=0.8.8
ARG ncurses_version=6.5
ARG ALPINE_REPOSITORY=https://dl-cdn.alpinelinux.org/alpine

RUN sed -i "s#https://dl-cdn.alpinelinux.org/alpine#${ALPINE_REPOSITORY}#g" /etc/apk/repositories && \
    apk add --no-cache \
        build-base \
        libpcap-dev \
        linux-headers \
        ncurses

WORKDIR /build

ADD https://invisible-island.net/archives/ncurses/ncurses-${ncurses_version}.tar.gz /build/ncurses.tar.gz
ADD https://github.com/raboof/nethogs/archive/refs/tags/v${app_version}.tar.gz /build/nethogs.tar.gz

RUN tar -xzf ncurses.tar.gz && \
    cd ncurses-${ncurses_version} && \
    CFLAGS="-O2 -std=gnu17" ./configure \
        --prefix=/build/ncurses \
        --disable-database \
        --enable-widec \
        --with-fallbacks=xterm,xterm-256color,screen,screen-256color,linux,vt100 \
        --with-normal \
        --without-ada \
        --without-cxx-binding \
        --without-debug \
        --without-shared \
        --without-termlib && \
    make -j2 && \
    grep -q 'fallback entries for:.*xterm-256color' ncurses/fallback.c && \
    make install && \
    cd /build && \
    tar -xzf nethogs.tar.gz && \
    cd nethogs-${app_version} && \
    make -j2 nethogs \
        VERSION=${app_version} \
        CPPFLAGS="-I/build/ncurses/include -I/build/ncurses/include/ncursesw" \
        LDFLAGS="-static -L/build/ncurses/lib" \
        NCURSES_LIBS="-lncursesw" && \
    make install \
        VERSION=${app_version} \
        PREFIX=/packs/nethogs \
        CPPFLAGS="-I/build/ncurses/include -I/build/ncurses/include/ncursesw" \
        LDFLAGS="-static -L/build/ncurses/lib" \
        NCURSES_LIBS="-lncursesw" && \
    strip /packs/nethogs/sbin/nethogs && \
    ! ldd /packs/nethogs/sbin/nethogs 2>&1 | grep -q '=>'

WORKDIR /packs

FROM alpine

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}

WORKDIR /packs
