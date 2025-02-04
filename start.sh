#!/bin/bash

# 打印环境变量的值
echo "PROXY_USERNAME: ${PROXY_USERNAME}"
echo "PROXY_PASSWORD: ${PROXY_PASSWORD}"
echo "SOCKS5_MODE: ${SOCKS5_MODE}"
echo "WARP_LICENSE_ID: ${WARP_LICENSE_ID}"

# 启动 warp-svc 并将其输出重定向到日志文件
nohup /usr/bin/warp-svc > /app/warp.log &

# 等待 5 秒，确保 warp-svc 启动完成
sleep 5

# 注册新的 Warp 客户端
warp-cli --accept-tos registration new

# 如果提供了 WARP_LICENSE_ID，则设置 WARP+ license
if [ -n "$WARP_LICENSE_ID" ]; then
    echo "Setting WARP+ license: ${WARP_LICENSE_ID}"
    warp-cli registration license "${WARP_LICENSE_ID}"
fi

# 设置 Warp 模式为代理
warp-cli --accept-tos mode proxy

# 连接到 Warp
warp-cli --accept-tos connect

# 设置代理认证信息
PROXY_AUTH=""

if [ -n "$PROXY_USERNAME" ] && [ -n "$PROXY_PASSWORD" ]; then
    PROXY_AUTH="${PROXY_USERNAME}:${PROXY_PASSWORD}@"
fi

# 根据 SOCKS5_MODE 变量的值选择模式
if [ -n "$SOCKS5_MODE" ]; then
    # 启用 SOCKS5 模式，支持 TCP 和 UDP，并添加认证
    echo "Starting SOCKS5 proxy with authentication: ${PROXY_AUTH}"
    /app/gost -L "socks5://${PROXY_AUTH}:1080" -F "socks5://127.0.0.1:40000"
else
    # 启用 HTTP 模式，并添加认证
    echo "Starting HTTP proxy with authentication: ${PROXY_AUTH}"
    /app/gost -L "http://${PROXY_AUTH}:1080" -F "socks5://127.0.0.1:40000"
fi
