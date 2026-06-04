# JDK21 + Maven 开发环境

基于 `debian:12.10-slim`，安装 JDK21 (Temurin) + Maven，并配置 SSH 服务，供远程开发使用。

## 特性

- JDK21: Eclipse Temurin（默认 `21.0.6+7`）
- Maven: 默认 `3.9.9`
- SSH 端口: `2222`
- 默认用户: `normaluser` / `123456`，具有 sudo 权限
- root 密码: `123456`

## 构建

```bash
docker build -t javadev:21 .

# 指定版本
docker build --build-arg app_version=21.0.6+7 --build-arg maven_version=3.9.6 -t javadev:21.0.6 .
```

## 运行

```bash
docker run -d \
  --name javadev21 \
  -p 2222:2222 \
  -v $(pwd)/workspace:/home/normaluser/workspace \
  -v $(pwd)/m2:/home/normaluser/.m2/repository \
  javadev:21
```

## SSH 连接

```bash
ssh -p 2222 normaluser@localhost
# 密码: 123456
```