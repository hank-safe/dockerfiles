ARG app_version=stable
FROM nginx:${app_version}

# 安装vim，方便内部编辑配置文件
RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y vim \
    && apt-get install --no-install-recommends --no-install-suggests -y logrotate cron \
    && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/*

COPY deploy.sh /opt/
COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
ENTRYPOINT ["/bin/bash","/opt/deploy.sh"]
