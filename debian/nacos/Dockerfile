# ccr.ccs.tencentyun.com/hank997/nacos-server:2.4.3
FROM  crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/openjdk:8u462-slim-12.10

LABEL maintainer "Hank"
LABEL github "https://github.com/agocan"

# 设置环境变量
ENV MODE="cluster" \
    PREFER_HOST_MODE="ip"\
    BASE_DIR="/home/nacos" \
    CLASSPATH=".:/home/nacos/conf:$CLASSPATH" \
    CLUSTER_CONF="/home/nacos/conf/cluster.conf" \
    FUNCTION_MODE="all" \
    NACOS_USER="nacos" \
    JVM_XMS="1g" \
    JVM_XMX="1g" \
    JVM_XMN="512m" \
    JVM_MS="128m" \
    JVM_MMS="320m" \
    NACOS_DEBUG="n" \
    TOMCAT_ACCESSLOG_ENABLED="false" \
    TIME_ZONE="Asia/Shanghai"

ARG app_version=2.4.3
ARG HOT_FIX_FLAG=""
ARG https_proxy

WORKDIR $BASE_DIR

RUN apt-get update && apt-get install curl -y

# 下载并安装 Nacos
RUN set -x \
    && curl -SL "https://github.com/alibaba/nacos/releases/download/${app_version}${HOT_FIX_FLAG}/nacos-server-${app_version}.tar.gz" -o nacos-server.tar.gz \
    && tar -xzvf nacos-server.tar.gz -C /home \
    && rm -rf nacos-server.tar.gz /home/nacos/bin/* /home/nacos/conf/*.properties /home/nacos/conf/*.example /home/nacos/conf/nacos-mysql.sql \
    && ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone

ADD bin/docker-startup.sh bin/docker-startup.sh
ADD conf/application.properties conf/application.properties

# 设置启动日志目录
RUN mkdir -p logs \
	&& touch logs/start.out \
	&& ln -sf /dev/stdout logs/start.out \
	&& ln -sf /dev/stderr logs/start.out \
    && chmod +x bin/docker-startup.sh

EXPOSE 8848
CMD ["bash","bin/docker-startup.sh"]