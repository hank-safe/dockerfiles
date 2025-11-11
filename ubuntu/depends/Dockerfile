# 22.04
FROM --platform=linux/amd64 ubuntu:22.04 AS ubuntu-22.04-amd64-debs

WORKDIR /debs

COPY download.sh /debs

RUN bash download.sh && rm -f download.sh


FROM --platform=linux/arm64 ubuntu:22.04 AS ubuntu-22.04-arm64-debs
WORKDIR /debs

COPY download.sh /debs

RUN bash download.sh && rm -f download.sh

# 24.04
FROM --platform=linux/amd64 ubuntu:24.04 AS ubuntu-24.04-amd64-debs

WORKDIR /debs

COPY download.sh /debs

RUN bash download.sh && rm -f download.sh


FROM --platform=linux/arm64 ubuntu:24.04 AS ubuntu-24.04-arm64-debs
WORKDIR /debs

COPY download.sh /debs

RUN bash download.sh && rm -f download.sh

FROM busybox:1.37.0

WORKDIR /debs
RUN mkdir -p /debs/x86_64 && \
    mkdir -p /debs/aarch64

COPY --from=ubuntu-22.04-amd64-debs /debs/ /debs/x86_64/ubuntu22.04
COPY --from=ubuntu-22.04-arm64-debs /debs/ /debs/aarch64/ubuntu22.04

COPY --from=ubuntu-24.04-amd64-debs /debs/ /debs/x86_64/ubuntu24.04
COPY --from=ubuntu-24.04-arm64-debs /debs/ /debs/aarch64/ubuntu24.04



