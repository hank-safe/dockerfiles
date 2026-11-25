ARG app_version=stable
FROM nginx:${app_version}
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources
RUN apt-get update && apt-get install -y cron rsyslog logrotate libvshadow-utils sudo
RUN userdel nginx \
    && groupadd -r -g 10000 nginx \
    && useradd --no-log-init -r -g 10000 -u 10000 nginx \
    && chown -R nginx:nginx /var/cache/nginx \
    && touch /var/run/nginx.pid \
    && chown nginx:nginx /var/run/nginx.pid
USER nginx
