FROM alpine:3.20.4 AS builder

ARG app_version=1.08.0

RUN apk add --no-cache build-base texinfo wget xz

WORKDIR /build

RUN wget -O bc.tar.xz "https://ftp.gnu.org/gnu/bc/bc-${app_version}.tar.xz" && \
    tar -xf bc.tar.xz && \
    cd "bc-${app_version}" && \
    CFLAGS="-Os -std=gnu17" \
    LDFLAGS="-static" \
    ./configure \
        --prefix=/packs/bc \
        --without-readline \
        --without-libedit && \
    make -j2 && \
    make install && \
    strip /packs/bc/bin/bc /packs/bc/bin/dc && \
    ! ldd /packs/bc/bin/bc 2>&1 | grep -q '=>' && \
    ! ldd /packs/bc/bin/dc 2>&1 | grep -q '=>' && \
    printf 'scale=3; 10 / 3\n' | /packs/bc/bin/bc | grep -qx '3.333'

FROM alpine:3.20.4

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}

WORKDIR /packs
