#!/bin/bash
set -e

# 将当前容器环境变量（包含 Kubernetes 注入的变量）写入 /etc/environment
# 使 SSH 登录时 pam_env.so 能够加载这些变量
printenv | grep -v '^_=' | while IFS='=' read -r key value; do
    # 跳过空 key 或包含特殊字符的 key
    [[ -z "$key" || "$key" =~ [^a-zA-Z0-9_] ]] && continue
    printf '%s="%s"\n' "$key" "$value"
done | sudo tee /etc/environment > /dev/null

# 使用 sudo 以 root 身份启动 sshd
sudo /usr/sbin/sshd -D