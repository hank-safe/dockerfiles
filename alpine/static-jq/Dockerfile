FROM alpine AS builder

ARG app_version=1.8.1

RUN apk add wget

WORKDIR /build

RUN arch="$(dpkg --print-architecture)"; \
    case "$arch" in \
        'amd64') downloadUrl="https://github.com/jqlang/jq/releases/download/jq-${app_version}/jq-linux-amd64"; \
        ;; \
        'arm64') downloadUrl="https://github.com/jqlang/jq/releases/download/jq-${app_version}/jq-linux-arm64"; \
        ;; \
        *) echo >&2 "error: unsupported architecture: '$arch'"; exit 1; \
        ;; \
    esac; \
    wget -O /packs/j1 "$downloadUrl";
WORKDIR /packs

FROM alpine

COPY --from=builder /packs /packs

WORKDIR /packs

