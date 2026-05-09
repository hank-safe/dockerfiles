
```
RUN node_version=24.15.0 && apt-get update && apt-get install -y xz-utils && \
    case "$(arch)" in \
        x86_64) arch_m="x64" ;; \
        aarch64) arch_m="arm64" ;; \
        *) echo >&2 "error: unsupported version: '$app_version'"; exit 1 ;; \
    esac && \
    wget https://nodejs.org/dist/v${node_version}/node-v${node_version}-linux-${arch_m}.tar.xz && \
    tar xf node-v${node_version}-linux-${arch_m}.tar.xz -C /usr/local/ && \
    rm -f node-v${node_version}-linux-${arch_m}.tar.xz && \
    ln -sf /usr/local/node-v${node_version}-linux-${arch_m} /usr/local/node

ENV PATH=$PATH:/usr/local/node/bin

RUN npm install -g @openai/codex

RUN sed -i '43asession        required      pam_env.so envfile=/etc/environment' /etc/pam.d/sshd

# 配置 Go 环境变量，确保 SSH 登录时也可用
RUN echo 'export PATH=/usr/local/node/bin:/go/bin:/usr/local/go/bin:$PATH' > /etc/profile.d/golang.sh && \
    echo 'export GOPATH=/go' >> /etc/profile.d/golang.sh && \
    echo 'export GOTOOLCHAIN=local' >> /etc/profile.d/golang.sh && \
    echo 'export GOLANG_VERSION=${GOLANG_VERSION}' >> /etc/profile.d/golang.sh

```