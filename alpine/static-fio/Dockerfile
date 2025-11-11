FROM alpine

ARG app_version=3.36

RUN apk add build-base gcc musl-dev && \
    apk add linux-headers zlib-dev openssl-dev libaio-dev

RUN wget -O fio.tar.gz  https://github.com/axboe/fio/archive/refs/tags/fio-${app_version}.tar.gz && \
    tar xf fio.tar.gz && \
    cd fio-fio-${app_version} && \
    ./configure --prefix=/out/fio --build-static && \
    make -j && \
    make install && \
    mkdir -p /out/fio && \
    strip /out/fio/bin/fio && \
    chown -R $(id -u):$(id -g) /out/fio && \
    mkdir -p /packs && \
    cp -a /out/fio /packs
