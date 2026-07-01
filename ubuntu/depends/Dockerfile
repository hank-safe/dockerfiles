FROM ubuntu:22.04 AS ubuntu-22.04-debs

WORKDIR /debs
COPY download.sh /debs
RUN bash download.sh && rm -f download.sh


FROM ubuntu:24.04 AS ubuntu-24.04-debs

WORKDIR /debs
COPY download.sh /debs
RUN bash download.sh && rm -f download.sh

FROM busybox:1.37.0

ARG TARGETARCH
WORKDIR /packs/${TARGETARCH}/debs
COPY --from=ubuntu-22.04-debs /debs/ ./ubuntu22.04
COPY --from=ubuntu-24.04-debs /debs/ ./ubuntu24.04

WORKDIR /packs
