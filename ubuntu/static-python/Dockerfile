FROM ubuntu:22.04 AS builder
# 静态编译后，python的路径就是写死的，因为下载的pypi包需要保存
ARG app_version=3.11.6
ENV app_version=${app_version}

ARG BUILD_THREADS=8
ENV BUILD_THREADS=${BUILD_THREADS}

RUN apt update && apt install -y build-essential tar gdb lcov pkg-config \
      libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
      libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
      lzma lzma-dev uuid-dev zlib1g-dev wget coreutils

RUN mkdir -p /opt/python && mkdir -p /src && wget https://www.python.org/ftp/python/${app_version}/Python-${app_version}.tgz && tar -xzf Python-${app_version}.tgz -C /src 

COPY Setup.local/${app_version} /src/Python-${app_version}/Modules/Setup.local

RUN cd /src/Python-${app_version} && \
    ./configure LDFLAGS="-static" --disable-shared --prefix=/usr/local/python${app_version} --enable-optimizations --with-openssl=/usr/include/openssl 

RUN cd /src/Python-${app_version} && make LDFLAGS="-static" LINKFORSHARED=" " -j ${BUILD_THREADS}

RUN cd /src/Python-${app_version} && make install -j ${BUILD_THREADS}

RUN mkdir -p /packs/ && cp -a /usr/local/python${app_version} /packs/

FROM ubuntu:22.04

COPY --from=builder /packs /packs

WORKDIR /packs
