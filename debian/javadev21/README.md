# JDK8 + Maven 开发环境

基于 `debian:12.10-slim`，安装 JDK8 (Temurin) + Maven，并配置 SSH 服务，供远程开发使用。

## 特性

- JDK8: Eclipse Temurin（默认 `8u462-b08`）
- Maven: 默认 `3.9.9`
- SSH 端口: `2222`
- 默认用户: `normaluser` / `123456`，具有 sudo 权限
- root 密码: `123456`

## 构建

```bash
docker build -t javadev:latest .

# 指定版本
docker build --build-arg app_version=8u422-b05 --build-arg maven_version=3.9.6 -t javadev:8u422 .
```

## 运行

```bash
docker run -d \
  --name javadev \
  -p 2222:2222 \
  -v $(pwd)/workspace:/home/normaluser/workspace \
  -v $(pwd)/m2:/home/normaluser/.m2/repository \
  javadev:latest
```

## SSH 连接

```bash
ssh -p 2222 normaluser@localhost
# 密码: 123456
```
