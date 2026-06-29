FROM alpine AS builder

ARG app_version=7.4

RUN apk add gcc g++ musl-dev make automake autoconf build-base linux-headers

WORKDIR /build

RUN wget -O smartmontools.tar.gz https://sourceforge.net/projects/smartmontools/files/smartmontools/${app_version}/smartmontools-${app_version}.tar.gz && \
    tar xf smartmontools.tar.gz && \
    cd smartmontools-${app_version} && \
    LDFLAGS="-static" CXXFLAGS="-O2" ./configure --prefix=/packs/smartmontools && \
    make -j$(nproc) && \
    make install && \
    strip /packs/smartmontools/sbin/smartctl && \
    strip /packs/smartmontools/sbin/smartd && \
    chown -R $(id -u):$(id -g) /packs/smartmontools

WORKDIR /packs

FROM alpine

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}


WORKDIR /packs
