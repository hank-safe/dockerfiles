FROM alpine AS builder

ARG app_version=2.9.1

RUN apk add wget

WORKDIR /packs

RUN arch="$(arch)"; \
    case "$arch" in \
        'x86_64') download_arch='x86_64'; \
        ;; \
        'aarch64') download_arch='aarch64'; \
        ;; \
        *) echo >&2 "error: unsupported architecture: '$arch'"; exit 1; \
        ;; \
    esac; \
    wget -O /tmp/ncdu.tar.gz "https://dev.yorhel.nl/download/ncdu-${app_version}-linux-${download_arch}.tar.gz"; \
    tar -xzf /tmp/ncdu.tar.gz -C /packs; \
    chmod +x /packs/ncdu

FROM alpine

ARG TARGETARCH

WORKDIR /packs/${TARGETARCH}
COPY --from=builder /packs /packs/${TARGETARCH}

WORKDIR /packs
