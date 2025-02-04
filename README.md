---

# Canal

一个开箱即用的 HTTP / SOCKS5 代理（基于 Cloudflare WARP）

Canal 是一个基于 Cloudflare WARP 的 Docker 镜像，提供 HTTP 和 SOCKS5 代理服务。它支持 WARP+ 的 license 配置，并可以通过环境变量灵活配置代理模式和认证信息。

---

## 功能特性

- **HTTP 代理模式**：支持 HTTP 代理，适用于浏览器和其他 HTTP 客户端。
- **SOCKS5 代理模式**：支持 SOCKS5 代理，支持 TCP 和 UDP 协议。
- **WARP+ 支持**：可选配置 WARP+ license，提升代理性能。
- **认证支持**：支持通过环境变量配置 HTTP/SOCKS5 代理的用户名和密码认证。
- **开箱即用**：无需复杂配置，一键部署。

---

## 部署

### 1. HTTP 代理模式

#### 部署命令
```bash
docker run -d -p 127.0.0.1:1080:1080 --name canal gua12345/warp-socks-arm:latest
```

#### 测试代理
```bash
curl -x http://127.0.0.1:1080 ipinfo.io
```

---

### 2. SOCKS5 代理模式

#### 部署命令
```bash
docker run -d -p 127.0.0.1:1080:1080/tcp -p 127.0.0.1:1080:1080/udp -e SOCKS5_MODE=true --name canal gua12345/warp-socks-arm:latest
```

#### 测试代理
```bash
curl --socks5 127.0.0.1:1080 ipinfo.io
```

---

### 3. 使用 WARP+（可选）

WARP+ 是 Cloudflare 提供的高级服务，可以通过配置 license 来提升代理性能。

#### 配置 WARP+ License

1. 在启动容器时，通过环境变量 `WARP_LICENSE_ID` 设置 WARP+ license：
   ```bash
   docker run -d -p 127.0.0.1:1080:1080 -e WARP_LICENSE_ID="your-license-id" --name canal gua12345/warp-socks-arm:latest
   ```

2. 如果容器已经运行，可以通过以下命令手动设置 WARP+ license：
   ```bash
   # 进入容器
   docker exec -it canal bash

   # 设置 WARP+ license
   warp-cli registration license <license id>

   # 退出容器
   exit

   # 重启容器以生效
   docker restart canal
   ```

---

### 4. 配置代理认证（可选）

Canal 支持通过环境变量配置 HTTP/SOCKS5 代理的用户名和密码认证。

#### 部署命令（带认证）
```bash
docker run -d -p 127.0.0.1:1080:1080 \
  -e PROXY_USERNAME="your-username" \
  -e PROXY_PASSWORD="your-password" \
  --name canal gua12345/warp-socks-arm:latest
```

#### 测试代理（带认证）
```bash
curl -x http://username:password@127.0.0.1:1080 ipinfo.io
```

---

## 环境变量

Canal 支持以下环境变量：

| 变量名             | 默认值   | 描述                                                                 |
|--------------------|----------|----------------------------------------------------------------------|
| `SOCKS5_MODE`      | `false`  | 是否启用 SOCKS5 模式。设置为 `true` 启用 SOCKS5 模式，否则启用 HTTP 模式。 |
| `PROXY_USERNAME`   | 无       | HTTP/SOCKS5 代理的用户名（可选）。                                   |
| `PROXY_PASSWORD`   | 无       | HTTP/SOCKS5 代理的密码（可选）。                                     |
| `WARP_LICENSE_ID`  | 无       | WARP+ 的 license ID（可选）。                                        |

---

## 示例

### 1. 启用 SOCKS5 模式并配置认证
```bash
docker run -d -p 127.0.0.1:1080:1080/tcp -p 127.0.0.1:1080:1080/udp \
  -e SOCKS5_MODE=true \
  -e PROXY_USERNAME="admin" \
  -e PROXY_PASSWORD="password" \
  --name canal gua12345/warp-socks-arm:latest
```

### 2. 启用 HTTP 模式并配置 WARP+ license
```bash
docker run -d -p 127.0.0.1:1080:1080 \
  -e WARP_LICENSE_ID="your-license-id" \
  --name canal gua12345/warp-socks-arm:latest
```

---

## 常见问题

### 1. 如何查看容器日志？
```bash
docker logs canal
```

### 2. 如何停止并删除容器？
```bash
docker stop canal
docker rm canal
```

### 3. 如何更新容器？
```bash
docker stop canal
docker rm canal
docker pull gua12345/warp-socks-arm:latest
docker run -d -p 127.0.0.1:1080:1080 --name canal gua12345/warp-socks-arm:latest
```

---

## License

MIT License

---
