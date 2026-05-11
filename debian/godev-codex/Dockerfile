# https://github.com/docker-library/golang
ARG app_version=1.26.2

FROM golang:${app_version}

# 安装一些依赖包，并且做好 ssh的配置
RUN apt-get update && \
    apt-get install -y git vim wget openssh-server sudo screen locales && \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen && \
    wget -O $(ls -d /usr/share/vim/vim*)/basic.vim https://raw.githubusercontent.com/amix/vimrc/refs/heads/master/vimrcs/basic.vim && \
    sed -i 's#mouse=a#mouse-=a#g' $(ls -d /usr/share/vim/vim*)/defaults.vim

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN addgroup --gid 1008 normaluser && \
    adduser --system --disabled-password --home /home/normaluser -u 1008 --ingroup normaluser normaluser --shell /bin/bash && \
    echo normaluser ALL=\(ALL\) NOPASSWD:ALL >> /etc/sudoers && \
    chown -R normaluser:normaluser /go && \
    echo "alias ls='ls --color=auto'" >> /home/normaluser/.bashrc
    
WORKDIR /home/normaluser

RUN echo "Port 2222" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config

RUN echo 'normaluser:123456' |chpasswd && \
    echo 'root:123456' |chpasswd

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
    echo 'export GOLANG_VERSION=${GOLANG_VERSION}' >> /etc/profile.d/golang.sh && \
    echo "alias ls='ls --color=auto'" >> /etc/profile.d/alias.sh && \
    echo "LANG=en_US.UTF-8" >> /etc/profile.d/locale.sh && \
    echo "LC_ALL=en_US.UTF-8" >> /etc/profile.d/locale.sh


# 复制启动脚本，动态设置 /run/sshd 权限
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

COPY ssh /home/normaluser/.ssh
COPY ssh /root/.ssh
RUN chown -R normaluser:normaluser /home/normaluser/.ssh && \
    chown -R root:root /root/.ssh && \
    chmod 700 /home/normaluser/.ssh && \
    chmod 600 /home/normaluser/.ssh/* && \
    chmod 644 /home/normaluser/.ssh/id_rsa.pub && \
    chmod 700 /root/.ssh && \
    chmod 600 /root/.ssh/* && \
    chmod 644 /root/.ssh/id_rsa.pub

CMD ["/usr/local/bin/start.sh"]
