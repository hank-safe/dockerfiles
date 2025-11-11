FROM alpine AS builder

ARG app_version=1.8.1

RUN apk add wget

WORKDIR /packs

RUN arch="$(arch)"; \
    case "$arch" in \
        'x86_64') downloadUrl="https://github.com/jqlang/jq/releases/download/jq-${app_version}/jq-linux-amd64"; \
        ;; \
        'aarch64') downloadUrl="https://github.com/jqlang/jq/releases/download/jq-${app_version}/jq-linux-arm64"; \
        ;; \
        *) echo >&2 "error: unsupported architecture: '$arch'"; exit 1; \
        ;; \
    esac; \
    wget -O /packs/jq "$downloadUrl";

FROM alpine

COPY --from=builder /packs /packs

WORKDIR /packs

