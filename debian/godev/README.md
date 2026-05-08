# Go Development Environment

基于 Debian 的 Go 开发环境，预装了常用的开发工具和 VSCode Go 扩展依赖。

## 快速启动

```bash
# 启动容器（后台运行）
docker compose up -d

# 查看容器状态
docker compose ps

# 查看日志
docker compose logs -f

# 停止容器
docker compose down

# 进入容器
docker exec -it godev bash
```

## SSH 连接

```bash
ssh normaluser@localhost -p 2222
# 密码: 123456

# 或使用 root 登录
ssh root@localhost -p 2222
# 密码: 123456
```

## 端口说明

| 服务 | 容器端口 | 映射端口 |
|------|---------|---------|
| SSH  | 2222    | 2222    |

## 目录挂载

本地 `./workspace` 目录会挂载到容器的 `/home/normaluser/workspace`。
