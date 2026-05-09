# https://github.com/docker-library/golang
ARG app_version=1.26.2

FROM golang:${app_version}

# 安装一些依赖包，并且做好 ssh的配置
RUN apt-get update && \
    apt-get install -y git vim wget openssh-server sudo screen && \
    wget -O $(ls -d /usr/share/vim/vim*)/basic.vim https://raw.githubusercontent.com/amix/vimrc/refs/heads/master/vimrcs/basic.vim && \
    sed -i 's#mouse=a#mouse-=a#g' $(ls -d /usr/share/vim/vim*)/defaults.vim 

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

RUN sed -i '43asession        required      pam_env.so envfile=/etc/environment' /etc/pam.d/sshd

# 配置 Go 环境变量，确保 SSH 登录时也可用
RUN echo 'export PATH=/go/bin:/usr/local/go/bin:$PATH' > /etc/profile.d/golang.sh && \
    echo 'export GOPATH=/go' >> /etc/profile.d/golang.sh && \
    echo 'export GOTOOLCHAIN=local' >> /etc/profile.d/golang.sh && \
    echo 'export GOLANG_VERSION=${GOLANG_VERSION}' >> /etc/profile.d/golang.sh && \
    echo "alias ls='ls --color=auto'" >> /etc/profile.d/alias.sh

# 复制启动脚本，动态设置 /run/sshd 权限
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
