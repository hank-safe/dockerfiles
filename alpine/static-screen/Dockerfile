FROM alpine AS builder

ARG app_version=5.0.1

RUN apk add --no-cache build-base ncurses-static ncurses-dev curl tar

WORKDIR /build

RUN wget -O screen.tar.xz \
      https://ftp.gnu.org/gnu/screen/screen-${app_version}.tar.gz \
    && tar -xvf screen.tar.xz \
    && cd screen-${app_version} \
    && ./configure --prefix=/packs/screen \
                LDFLAGS="-static" \
                LIBS="-lncursesw -ltinfo" \
                --disable-pam \
    && make -j2 \
    && make install 

WORKDIR /packs

FROM alpine

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}

WORKDIR /packs

