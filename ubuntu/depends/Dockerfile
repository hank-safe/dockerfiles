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

WORKDIR /packs
RUN mkdir -p /packs/amd64/debs && \
    mkdir -p /packs/arm64/debs

COPY --from=ubuntu-22.04-amd64-debs /debs/ /packs/amd64/debs/ubuntu22.04
COPY --from=ubuntu-22.04-arm64-debs /debs/ /packs/arm64/debs/ubuntu22.04

COPY --from=ubuntu-24.04-amd64-debs /debs/ /packs/amd64/debs/ubuntu24.04
COPY --from=ubuntu-24.04-arm64-debs /debs/ /packs/arm64/debs/ubuntu24.04


