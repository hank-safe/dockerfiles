FROM ubuntu:22.04 AS builder

LABEL maintainer "Hank"
LABEL github "https://github.com/agocan"

ARG app_version=1.27.4

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libpcre3 libpcre3-dev \
    zlib1g zlib1g-dev \
    libssl-dev \
    libxml2 libxml2-dev libxslt1.1 libxslt1-dev \
    wget git && \
    rm -rf /var/lib/apt/lists/*

COPY nginx-dav-ext-module /app/nginx-dav-ext-module

RUN wget http://nginx.org/download/nginx-${app_version}.tar.gz && \
    tar xf nginx-${app_version}.tar.gz && \
    cd nginx-${app_version} && \
    ./configure --prefix=/usr/local/nginx \
                --pid-path=/var/run/nginx.pid \
                --lock-path=/var/run/nginx.lock \
                --with-http_ssl_module \
                --with-http_dav_module \
                --add-module=../nginx-dav-ext-module && \
    make -j && \
    make install 

FROM ubuntu:22.04

COPY --from=builder /usr/local/nginx /usr/local/nginx

WORKDIR /usr/local/nginx

RUN apt-get update && apt-get install -y \
    apache2-utils libxml2 && \
    rm -rf /var/lib/apt/lists/*
    
# 创建 WebDAV 数据目录
RUN mkdir -p /data/dav
# 设置权限（WebDAV 需要写入权限）
RUN chmod -R 755 /data/dav
# 创建 Basic Auth 用户认证文件
RUN htpasswd -cb /usr/local/nginx/conf/.htpasswd admin password
# 替换默认的 Nginx 配置文件，启用 WebDAV 模块
COPY nginx.conf /usr/local/nginx/conf/nginx.conf
# 暴露端口
EXPOSE 80

RUN ln -s /dev/stdout /usr/local/nginx/logs/access.log && \
ln -s /dev/stdout /usr/local/nginx/logs/error.log

# 启动 Nginx
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
