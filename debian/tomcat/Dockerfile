FROM crpi-p2k20xc75i1dtww9.cn-guangzhou.personal.cr.aliyuncs.com/hank997/openjdk:8u462-b08

LABEL maintainer "Hank"
LABEL github "https://github.com/agocan"

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

ENV app_version=9.0.112

RUN curl -o tomcat.tar.gz https://dlcdn.apache.org/tomcat/tomcat-9/v${app_version}/bin/apache-tomcat-${app_version}.tar.gz && \
    tar xf tomcat.tar.gz && \
    mv apache-tomcat-${app_version} /opt/tomcat && \
    rm -f tomcat.tar.gz

ENV PATH=/opt/tomcat/bin:/usr/local/openjdk-8/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

CMD ["catalina.sh", "run"]
