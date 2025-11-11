FROM alpine

ARG app_version=5.3.2

RUN apk add gcc musl-dev make automake autoconf ncurses-dev build-base && \
    apk add ncurses-static linux-headers


RUN wget -O gawk.tar.gz  https://ftp.gnu.org/gnu/gawk/gawk-${app_version}.tar.gz && \
    tar xf gawk.tar.gz && \
    cd gawk-${app_version} && \
    LDFLAGS="-static" PKG_CONFIG="pkg-config --static" ./configure --prefix=/usr/local/gawk && \
    make -j && \
    make install && \
    mkdir -p /out/ && \
    mv /usr/local/gawk /out/ && \
    strip /out/gawk/bin/gawk && \
    chown -R $(id -u):$(id -g) /out/gawk && \
    mkdir -p /packs && \
    cp -a /out/gawk /packs
