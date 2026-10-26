ARG app_version=8.4.1

FROM intellif.io/elasticsearch/elasticsearch:${app_version}

ARG app_version

WORKDIR /tmp

# 安装 Pinyin 分词器（拼音搜索）
RUN set -eux; \
    /usr/share/elasticsearch/bin/elasticsearch-plugin install --batch \
        "https://get.infini.cloud/elasticsearch/analysis-pinyin/${app_version}" \
    || /usr/share/elasticsearch/bin/elasticsearch-plugin install --batch \
        "https://github.com/infinilabs/analysis-pinyin/releases/download/v${app_version}/elasticsearch-analysis-pinyin-${app_version}.zip"

# 安装 Kuromoji 分词器（日文，Elasticsearch 内置插件）
RUN set -eux; \
    /usr/share/elasticsearch/bin/elasticsearch-plugin install --batch analysis-kuromoji

# 验证插件安装
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin list
