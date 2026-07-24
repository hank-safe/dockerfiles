FROM alpine AS builder

ARG app_version=3.21

RUN apk add --no-cache \
    build-base \
    linux-headers \
    openssl-dev \
    openssl-libs-static

WORKDIR /build

RUN wget -O iperf3.tar.xz \
      https://github.com/esnet/iperf/archive/refs/tags/${app_version}.tar.gz \
    && tar -xvf iperf3.tar.xz \
    && cd iperf-${app_version} \
    && ./configure --prefix=/packs/iperf\
            --enable-static-bin \
            --enable-static \
            --disable-shared \
            --without-sctp \
    && make -j2 \
    && make install 

WORKDIR /packs

FROM alpine

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}

WORKDIR /packs

