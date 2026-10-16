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
    apt-get install -y python3 python3-pip dos2unix vim git curl wget&& \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://get.docker.com/ | sh

RUN mkdir -p /code && \
    cd /code && \
    echo six > requirements.txt && \
    echo setuptools==45.2.0 > requirements.txt && \
    echo PyYAML > requirements.txt && \
    echo requests > requirements.txt && \
    echo docopt > requirements.txt && \
    echo markupsafe > requirements.txt && \
    echo jinja2 > requirements.txt && \
    pip3 install -r /code/requirements.txt 
