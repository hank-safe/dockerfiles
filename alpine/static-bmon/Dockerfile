FROM alpine

ARG app_version=4.0

RUN apk add gcc musl-dev make automake autoconf  build-base && \
    apk add ncurses ncurses-static ncurses-dev libcap-dev libcap-static  confuse-dev libnl3-dev

RUN wget -O bmon.tar.gz  https://github.com/tgraf/bmon/releases/download/v${app_version}/bmon-${app_version}.tar.gz && \
    tar xf bmon.tar.gz && \
    cd bmon-${app_version} && \
    CFLAGS="-O0 -g3" ./configure --enable-static --disable-shared --prefix=/usr/local/bmon && \
    make -j && \
    make install && \
    mkdir -p /out/ && \
    mv /usr/local/bmon /out/ && \
    strip /out/bmon/bin/bmon && \
    chown -R $(id -u):$(id -g) /out/bmon && \
    mkdir -p /packs && \
    cp -a /out/bmon /packs