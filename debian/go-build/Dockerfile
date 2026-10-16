ARG app_version=1.22.2-bullseye

FROM golang:${app_version}
# 跟着其他
RUN apt-get update && apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
		pkg-config \
		wget \
	&& rm -rf /var/lib/apt/lists/*

# ci-tools需要使用的工具
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-venv dos2unix vim git curl wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://get.docker.com/ | sh

COPY requirements.txt /code/requirements.txt

RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir -r /code/requirements.txt

ENV PATH="/opt/venv/bin:${PATH}"
