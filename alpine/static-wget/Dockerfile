FROM alpine AS builder

ARG app_version=1.24.5
ARG PCRE_VERSION=8.45

# 安装构建依赖
RUN apk add --no-cache \
    build-base \
    clang \
    gcc \
    linux-headers \
    openssl-dev \
    zlib-dev \
    perl \
    openssl-libs-static \
    zlib-static \
    tar \
    wget

WORKDIR /build

# 编译 PCRE
RUN wget -O pcre.tar.gz https://sourceforge.net/projects/pcre/files/pcre/${PCRE_VERSION}/pcre-${PCRE_VERSION}.tar.gz && \
    tar xf pcre.tar.gz && \
    cd pcre-${PCRE_VERSION} && \
    CFLAGS="-O2 -pipe" LDFLAGS="-static" ./configure \
        --prefix=/opt/static-pcre \
        --disable-shared \
        --enable-static \
        --disable-cpp \
        --enable-utf8 \
        --enable-unicode-properties && \
    make -j$(nproc) && \
    make install

# 编译 wget
RUN wget -O wget.tar.gz https://ftp.gnu.org/gnu/wget/wget-${app_version}.tar.gz && \
    tar xf wget.tar.gz && \
    cd wget-${app_version} && \
    LDFLAGS="-static -L/opt/static-pcre/lib" \
    CPPFLAGS="-I/opt/static-pcre/include" \
    PKG_CONFIG="/usr/bin/pkg-config --static" \
    ./configure \
        --prefix=/packs/wget \
        --with-ssl=openssl \
        --with-pcre=yes \
        --sysconfdir=/etc \
        --disable-rpath && \
    make -j$(nproc) && \
    make install && \
    strip /packs/wget/bin/wget

WORKDIR /packs

FROM alpine

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}

WORKDIR /packs
