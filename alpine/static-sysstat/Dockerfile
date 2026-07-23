FROM alpine AS builder

ARG app_version=12.7.9

RUN apk add --no-cache \
    build-base \
    linux-headers \
    file \
    wget \
    xz

WORKDIR /build

RUN wget -O sysstat.tar.xz \
      https://github.com/sysstat/sysstat/archive/refs/tags/v{app_version}.tar.gz \
    && tar -xvf sysstat.tar.xz \
    && cd sysstat-${app_version} \
    && ./configure --prefix=/packs/rsync \
                    --disable-nls \
                    --disable-documentation \
                    --disable-sensors \
                    --disable-pcp \
                    LDFLAGS="-static" \
    && make -j2 \
    && make install 

WORKDIR /packs

FROM alpine

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}

WORKDIR /packs

