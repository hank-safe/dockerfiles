FROM alpine AS builder

ARG app_version=0.7.4
ARG ncurses_version=6.5
ARG ALPINE_REPOSITORY=https://dl-cdn.alpinelinux.org/alpine

RUN sed -i "s#https://dl-cdn.alpinelinux.org/alpine#${ALPINE_REPOSITORY}#g" /etc/apk/repositories && \
    apk add --no-cache \
        autoconf \
        automake \
        build-base

WORKDIR /build

ADD https://invisible-island.net/archives/ncurses/ncurses-${ncurses_version}.tar.gz /build/ncurses.tar.gz
ADD https://github.com/rolandriegel/nload/archive/refs/tags/v${app_version}.tar.gz /build/nload.tar.gz

RUN tar -xzf ncurses.tar.gz && \
    cd ncurses-${ncurses_version} && \
    CFLAGS="-O2 -std=gnu17" ./configure \
        --prefix=/build/ncurses \
        --enable-widec \
        --with-fallbacks=xterm,xterm-256color,screen,screen-256color,linux,vt100 \
        --with-normal \
        --without-ada \
        --without-cxx-binding \
        --without-debug \
        --without-shared \
        --without-termlib && \
    make -j2 && \
    make install && \
    cd /build && \
    tar -xzf nload.tar.gz && \
    cd nload-${app_version} && \
    sed -i \
        -e 's/AC_CHECK_LIB(ncurses, initscr)/AC_CHECK_LIB(ncursesw, initscr)/' \
        -e 's/AC_CHECK_LIB(form, new_form)/AC_CHECK_LIB(formw, new_form)/' \
        -e 's/ac_cv_lib_ncurses_initscr/ac_cv_lib_ncursesw_initscr/' \
        -e 's/ac_cv_lib_form_new_form/ac_cv_lib_formw_new_form/' \
        configure.in && \
    autoreconf -fi && \
    CPPFLAGS="-I/build/ncurses/include -I/build/ncurses/include/ncursesw" \
    LDFLAGS="-static -L/build/ncurses/lib" \
    ./configure \
        --prefix=/packs/nload && \
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
